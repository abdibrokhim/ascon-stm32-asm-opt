/**
@file gost.c
Реализация функций шифрования ГОСТ28147-89.
*/
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "gost28147_89/gost.h"
/**
  @def _SWAPW32(W)
  Задает обратный порядок байт в 4х байтном числе. Для совместимости архитектур.
*/
#define _SWAPW32(W) ((W>>24) | (W<<24) | ((W>>8)&0xFF00) | ((W<<8)&0xFF0000))
/**
  @def _Min(W)
  Ищет минимальное значение между x и у
*/
#define _Min(x,y) (x>y?y:x)
/**
    @def _GOST_C0
    Константа С0 для задания начального значения псевдослучайного генератора гаммы.
*/
#define _GOST_C0 (uint32_t)(0x1010101)
/**
   @def _GOST_C1
   Константа С1 для задания начального значения псевдослучайного генератора гаммы.
*/
#define _GOST_C1 (uint32_t)(0x1010104)

/**
    @def _GOST_ADC32(x,y,c)
    Выполняет операцию c=(x+y)mod(2^32-1), т.е. с=x+y, если x+y<2^32 с=(uint32_t)(x+y)+1, если х+y>2^32
*/
#define _GOST_ADC32(x,y,c) c=(uint32_t)(x+y); c+=( ( c<x ) | ( c<y ) )

/**
    @def _GOST_SWAP32(x)
    Optimized byte-swap macro that reverses byte order in a 32-bit value.
    Faster alternative to __builtin_bswap32 for some platforms.
*/
#define _GOST_SWAP32(x) ((x>>24) | (x<<24) | ((x>>8)&0xFF00) | ((x<<8)&0xFF0000))

/**
@details GOST_Crypt_Step
Выполняет простейший шаг криптопреобразования(шифрования и расшифрования) ГОСТ28147-89
@param *DATA - Указатель на данные для зашифрования в формате GOST_Data_Part
@param *GOST_Table - Указатель на таблицу замены ГОСТ(ДК) в 128 байтном формате
(вместо старшого полубайта 0)
@param GOST_Key - 32хбитная часть ключа(СК).
@param Last - Является ли шаг криптопреобразования последним? Если да(true)-
результат будет занесен в 32х битный накопитель  N2, в противном случае предыдущие значение N1
сохраняется в N2, а результат работы будет занесен в накопитель N1.
*/
//GOST basic Simple Step
void GOST_Crypt_Step(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t GOST_Key, bool Last) {
    typedef union {
        uint32_t full;
        uint8_t parts[_GOST_TABLE_NODES/2];
    } GOST_Data_Part_sum;
    
    GOST_Data_Part_sum S;
    uint32_t n2 = (*DATA).half[_GOST_Data_Part_N2_Half];
    
    // N1=Lo(DATA); N2=Hi(DATA)
    // S=(N1+X)mod2^32
    S.full = (uint32_t)((*DATA).half[_GOST_Data_Part_N1_Half] + GOST_Key);
    
    // Process substitution table lookups all at once
    uint32_t result = 0;
    for (uint8_t m = 0; m < 4; m++) {
        uint8_t val = S.parts[m];
        uint8_t low_subst = *(GOST_Table + (val & 0x0F));
        uint8_t high_subst = *(GOST_Table + _GOST_TABLE_MAX_NODE_VALUE + ((val >> 4) & 0x0F));
        
        // Store substitution result
        uint8_t subst_result = low_subst | (high_subst << 4);
        
        // Add to result
        result |= ((uint32_t)subst_result << (8 * m));
        
        // Move to next byte's tables
        GOST_Table += 2 * _GOST_TABLE_MAX_NODE_VALUE;
    }
    
    // Rotate left by 11 bits and XOR with N2
    uint32_t rotated = (result << 11) | (result >> (32 - 11));
    S.full = n2 ^ rotated;
    
    // Update registers based on Last parameter
    if (Last) {
        (*DATA).half[_GOST_Data_Part_N2_Half] = S.full; // N2=S
    } else {
        (*DATA).half[_GOST_Data_Part_N2_Half] = (*DATA).half[_GOST_Data_Part_N1_Half]; // N2=N1
        (*DATA).half[_GOST_Data_Part_N1_Half] = S.full; // N1=S
    }
} // took 04:54 secs

/**
@details GOST_Crypt_32_E_Cicle
Базовый алгоритм выполняющий 32шага шифрования для 64-битной порции данных
(в номенклатуре документа ГОСТ28147-89 алгоритм 32-З), обратный алгоритму 32-Р.
@param *DATA - Указатель на данные для зашифрования в формате GOST_Data_Part
@param *GOST_Table - Указатель на таблицу замены ГОСТ(ДК) в 128 байтном формате
(вместо старшого полубайта 0)
@param GOST_Key - 32хбитная часть ключа(СК).
*/
void GOST_Crypt_32_E_Cicle(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t *GOST_Key)
{
    // First 24 rounds with keys K0-K7 repeated 3 times
    // Unroll first 8 rounds
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
    
    // Second set of 8 rounds
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
    
    // Third set of 8 rounds
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
    
    // Last 8 rounds with reversed key order (K7-K0)
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Last_Step);
}

/**
@details GOST_Crypt_32_D_Cicle
Базовый алгоритм выполняющий 32шага расшифрования для 64-битной порции данных
(в номенклатуре документа ГОСТ28147-89 алгоритм 32-Р), обратный алгоритму 32-З.
Применяется только в режиме простой замены.
@param *DATA - Указатель на данные для зашифрования в формате GOST_Data_Part
@param *GOST_Table - Указатель на таблицу замены ГОСТ(ДК) в 128 байтном формате
(вместо старшого полубайта 0)
@param GOST_Key - 32хбитная часть ключа(СК).
*/
//Basic 32-P decryption algorithm of GOST, usefull only in SR mode
void GOST_Crypt_32_D_Cicle(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t *GOST_Key)
{
    // Unroll all the loops for better performance
    // First 8 rounds with keys K0-K7
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
    
    // Reverse key order for remaining 24 rounds
    // First set of reverse key order
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Next_Step);
    
    // Second set of reverse key order
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Next_Step);
    
    // Third set of reverse key order (last 8 steps)
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Last_Step);
}

/**
@details GOST_Imitta_16_E_Cicle
Базовый алгоритм выполняющий 16 шагов расчета 64х битной имитовставки(в номенклатуре документа
ГОСТ28147-89 алгоритм 16-З).
@param *DATA - Указатель на данные для зашифрования в формате GOST_Data_Part
@param *GOST_Table - Указатель на таблицу замены ГОСТ(ДК) в 128 байтном формате
(вместо старшого полубайта 0)
@param GOST_Key - 32хбитная часть ключа(СК).
*/
//Imitta
void GOST_Imitta_16_E_Cicle(GOST_Data_Part *DATA, uint8_t *GOST_Table, uint32_t *GOST_Key)
{
    // Key rotation: K0,K1,K2,K3,K4,K5,K6,K7, K0,K1,K2,K3,K4,K5,K6,K7
    // Unroll both loops for better performance
    
    // First 8 rounds with keys K0-K7
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
    
    // Second 8 rounds with same keys K0-K7
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[0], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[1], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[2], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[3], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[4], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[5], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[6], _GOST_Next_Step);
    GOST_Crypt_Step(DATA, GOST_Table, GOST_Key[7], _GOST_Next_Step);
}

/**
@details GOST_Imitta
Подпрограма расчета имитовставки
@param *Open_Data - Указатель на данные для которых требуется расчитать имитовстаку.
@param *Imitta - Указатель на массив размером _GOST_Imitta_Size(64 бита), куда будет занесен результат
расчета имитовставки.
@param Size - Размер данных
@param *GOST_Table - Указатель на таблицу замены ГОСТ(ДК) в 128 байтном формате
(вместо старшого полубайта 0)
@param *GOST_Key - Указатель на 256 битный массив ключа(СК).
@attention  Для первого раунда массив Imitta должен быть заполнен _GOST_Def_Byte!
*/
//for first round Imitta must set to _GOST_Def_Byte
void GOST_Imitta(uint8_t *Open_Data, uint8_t *Imitta, uint32_t Size, uint8_t *GOST_Table, uint8_t *GOST_Key)
{
    GOST_Data_Part *Imitta_Prep = (GOST_Data_Part *)Imitta;
    GOST_Data_Part Open_Data_Prep;
    uint32_t *GOST_Key_ptr = (uint32_t *)GOST_Key;
    
    // Process full blocks directly
    while (Size >= _GOST_Part_Size) {
        // Load data directly without memcpy
        Open_Data_Prep = *((GOST_Data_Part *)Open_Data);
        
        // XOR with imitation accumulator
        (*Imitta_Prep).half[_GOST_Data_Part_N1_Half] ^= Open_Data_Prep.half[_GOST_Data_Part_N1_Half];
        (*Imitta_Prep).half[_GOST_Data_Part_N2_Half] ^= Open_Data_Prep.half[_GOST_Data_Part_N2_Half];
        
        // Run 16 encryption rounds
        GOST_Imitta_16_E_Cicle(Imitta_Prep, GOST_Table, GOST_Key_ptr);
        
        Size -= _GOST_Part_Size;
        Open_Data += _GOST_Part_Size;
    }
    
    // Handle remaining partial block if any
    if (Size > 0) {
        // Clear the prep buffer and copy partial data
        Open_Data_Prep.half[_GOST_Data_Part_N2_Half] = 0;
        Open_Data_Prep.half[_GOST_Data_Part_N1_Half] = 0;
        memcpy(&Open_Data_Prep, Open_Data, Size);
        
        // XOR with imitation accumulator
        (*Imitta_Prep).half[_GOST_Data_Part_N1_Half] ^= Open_Data_Prep.half[_GOST_Data_Part_N1_Half];
        (*Imitta_Prep).half[_GOST_Data_Part_N2_Half] ^= Open_Data_Prep.half[_GOST_Data_Part_N2_Half];
        
        // Run 16 encryption rounds
        GOST_Imitta_16_E_Cicle(Imitta_Prep, GOST_Table, GOST_Key_ptr);
    }
    
#if _GOST_ROT==1
    (*Imitta_Prep).half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32((*Imitta_Prep).half[_GOST_Data_Part_N1_Half]);
    (*Imitta_Prep).half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32((*Imitta_Prep).half[_GOST_Data_Part_N2_Half]);
#endif
}

/**
@details GOST_Encrypt_SR
Функция шифрования/расшифрования в режиме простой замены.
@param *Data - Указатель на данные для шифрования, также сюда заносится результат.
@param Size - Размер данных
@param Mode - Если _GOST_Mode_Encrypt шифрования, _GOST_Mode_Decrypt - расшифрование
@param *GOST_Table - Указатель на таблицу замены ГОСТ(ДК) в 128 байтном формате
(вместо старшого полубайта 0)
@param *GOST_Key - Указатель на 256 битный массив ключа(СК).
*/
void GOST_Encrypt_SR(uint8_t *Data, uint32_t Size, bool Mode, uint8_t *GOST_Table, uint8_t *GOST_Key ) {
    GOST_Data_Part Data_prep;
    uint32_t *GOST_Key_pt = (uint32_t *) GOST_Key;

    while (Size >= _GOST_Part_Size) {
        // Process full blocks directly without memcpy/memset
        Data_prep = *((GOST_Data_Part *)Data);
        
#if _GOST_ROT==1
        // Use the optimized byte-swap macro
        Data_prep.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
        Data_prep.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N1_Half]);
#endif
        if (Mode == _GOST_Mode_Encrypt) {
            GOST_Crypt_32_E_Cicle(&Data_prep, GOST_Table, GOST_Key_pt);
        } else {
            GOST_Crypt_32_D_Cicle(&Data_prep, GOST_Table, GOST_Key_pt);
        }
#if _GOST_ROT==1
        // Use the optimized byte-swap macro
        Data_prep.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
        Data_prep.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N1_Half]);
#endif
        // Copy result directly back to Data
        *((GOST_Data_Part *)Data) = Data_prep;
        
        Data += _GOST_Part_Size;
        Size -= _GOST_Part_Size;
    }
    
    // Handle remaining partial block if any
    if (Size > 0) {
        memset(&Data_prep, _GOST_Def_Byte, sizeof(Data_prep));
        memcpy(&Data_prep, Data, Size);
#if _GOST_ROT==1
        // Use the optimized byte-swap macro
        Data_prep.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
        Data_prep.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N1_Half]);
#endif
        if (Mode == _GOST_Mode_Encrypt) {
            GOST_Crypt_32_E_Cicle(&Data_prep, GOST_Table, GOST_Key_pt);
        } else {
            GOST_Crypt_32_D_Cicle(&Data_prep, GOST_Table, GOST_Key_pt);
        }
#if _GOST_ROT==1
        // Use the optimized byte-swap macro
        Data_prep.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N2_Half]);
        Data_prep.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(Data_prep.half[_GOST_Data_Part_N1_Half]);
#endif
        memcpy(Data, &Data_prep, Size);
    }
}

#if _GOST_ROT_Synchro_GAMMA==1
/**
@details GOST_Crypt_G_PS
Функция подготовки Синхропосылки для режима гаммирования. Должна быть вызвана до первого вызова
GOST_Crypt_G_Data. Если хранить синхропосылку в уже "развернутом" виде (поменять местами 32битные части), то функцию можно свести
к макросу вызова единичного шага криптопреобразования, для чего в файле gost.h установить
константу _GOST_ROT_Synchro_GAMMA=0. Синхропосылка это случайные данные, так что смысл функции
только в совместимости с входами еталонного шифратора.
@param *Synchro - Указатель на данные для шифрования, также сюда заносится результат.
@param *GOST_Table - Указатель на таблицу замены ГОСТ(ДК) в 128 байтном формате
(вместо старшого полубайта 0)
@param *GOST_Key - Указатель на 256 битный массив ключа(СК).
*/
void GOST_Crypt_G_PS(uint8_t *Synchro, uint8_t *GOST_Table, uint8_t *GOST_Key)
{
   uint32_t Tmp;
   GOST_Data_Part *GOST_Synchro_prep= (GOST_Data_Part *) Synchro;
   Tmp=(*GOST_Synchro_prep).half[_GOST_Data_Part_N2_Half];
   (*GOST_Synchro_prep).half[_GOST_Data_Part_N2_Half]=(*GOST_Synchro_prep).half[_GOST_Data_Part_N1_Half];
   (*GOST_Synchro_prep).half[_GOST_Data_Part_N1_Half]=Tmp;

   GOST_Crypt_32_E_Cicle(GOST_Synchro_prep, GOST_Table, (uint32_t *) GOST_Key);
}
#endif

/**
@details GOST_Crypt_G_Data
Шифрование\Расшифрования блока данных в режиме гаммирования.
@param *Data - Указатель на данные для шифрования\расшифрования, также сюда заносится результат работы.
@param Size - Размер данных
@param *Synchro - Указатель на синхопросылку, также сюда заносится текущее значение синхропосылки.
@param *GOST_Table - Указатель на таблицу замены ГОСТ(ДК) в 128 байтном формате(вместо старшого полубайта 0).
@param *GOST_Key - Указатель на 256 битный массив ключа(СК).
@attention Синхропосылка Synchro для первого вызова должна быть подготовлена функцией/макросом GOST_Crypt_G_PS.
*/
void GOST_Crypt_G_Data(uint8_t *Data, uint32_t Size, uint8_t *Synchro, uint8_t *GOST_Table, uint8_t *GOST_Key)
{
    GOST_Data_Part *S = (GOST_Data_Part *)Synchro;
    GOST_Data_Part Tmp;
    uint32_t *GOST_Key_ptr = (uint32_t *)GOST_Key;
    
    // Process full blocks (8 bytes at a time) when possible
    while (Size >= _GOST_Part_Size) {
        // Update synchro counter
        (*S).half[_GOST_Data_Part_N1_Half] += _GOST_C0;
        _GOST_ADC32((*S).half[_GOST_Data_Part_N2_Half], _GOST_C1, (*S).half[_GOST_Data_Part_N2_Half]);
        
        // Create gamma block
        Tmp = *S;
        GOST_Crypt_32_E_Cicle(&Tmp, GOST_Table, GOST_Key_ptr);
        
#if _GOST_ROT==1
        Tmp.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(Tmp.half[_GOST_Data_Part_N2_Half]);
        Tmp.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(Tmp.half[_GOST_Data_Part_N1_Half]);
#endif
        
        // XOR full block directly
        GOST_Data_Part *Data_ptr = (GOST_Data_Part *)Data;
        Data_ptr->half[0] ^= Tmp.half[0];
        Data_ptr->half[1] ^= Tmp.half[1];
        
        Data += _GOST_Part_Size;
        Size -= _GOST_Part_Size;
    }
    
    // Handle remaining partial block if any
    if (Size > 0) {
        // Update synchro counter
        (*S).half[_GOST_Data_Part_N1_Half] += _GOST_C0;
        _GOST_ADC32((*S).half[_GOST_Data_Part_N2_Half], _GOST_C1, (*S).half[_GOST_Data_Part_N2_Half]);
        
        // Create gamma block
        Tmp = *S;
        GOST_Crypt_32_E_Cicle(&Tmp, GOST_Table, GOST_Key_ptr);
        
#if _GOST_ROT==1
        Tmp.half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32(Tmp.half[_GOST_Data_Part_N2_Half]);
        Tmp.half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32(Tmp.half[_GOST_Data_Part_N1_Half]);
#endif
        
        // XOR remaining bytes
        for (uint8_t i = 0; i < Size; i++) {
            *Data ^= Tmp.parts[i];
            Data++;
        }
    }
}

#if _GOST_ROT_Synchro_GAMMA==1
/**
@details GOST_Crypt_GF_Prepare_S
Функция подготовки Синхропосылки для режима гаммирования с обратной связью.
Меняет местами 32битные части синхропосылки. Аналогично режиму гаммирования, если синхропосылка
хранится в "развернутом" виде(32х битные части поменяны местами) то функцию можно опустить.
Синхропосылка это случайные данные, так что смысл функции только в совместимости с
входами еталонного шифратора. Для упрощения жизни компилятору необходимо выставить константу
_GOST_ROT_Synchro_GAMMA=0 в gost.h.
@param *Synchro - Указатель на данные для шифрования, также сюда заносится результат.
*/
void GOST_Crypt_GF_Prepare_S(uint8_t *Synchro)
{
    GOST_Data_Part *S=(GOST_Data_Part *)Synchro;
    uint32_t Tmp=(*S).half[_GOST_Data_Part_N1_Half];
    (*S).half[_GOST_Data_Part_N1_Half]=(*S).half[_GOST_Data_Part_N2_Half];
    (*S).half[_GOST_Data_Part_N2_Half]=Tmp;
}
#endif

/**
@details GOST_Crypt_GF_Data
Функция шифрования в режиме гаммирования с обратной связью.
@param *Data - указатель на данные для шифрования/расшифрования.
@param Size - Размер данных
@param *Synchro - Указатель на синхопросылку,
также сюда заносится текущее значение синхропосылки.
@param Mode - Если _GOST_Mode_Encrypt будет выполнено шифрование данных,
если _GOST_Mode_Decrypt расшифрование
@param *GOST_Table - Указатель на таблицу замены ГОСТ(ДК) в 128 байтном формате
(вместо старшого полубайта 0).
@param *GOST_Key - Указатель на 256 битный массив ключа(СК).
@attention Если используется режим совместимости с входами еталонного шифратора, то синхропосылка
Synchro для первого вызова должна быть подготовлена функцией GOST_Crypt_GF_Prepare_S.
*/
void GOST_Crypt_GF_Data(uint8_t *Data, uint32_t Size, uint8_t *Synchro, bool Mode, uint8_t *GOST_Table, uint8_t *GOST_Key)
{
    GOST_Data_Part *S = (GOST_Data_Part *)Synchro;
    uint32_t *GOST_Key_ptr = (uint32_t *)GOST_Key;
    
    // Process full blocks (8 bytes at a time) when possible
    while (Size >= _GOST_Part_Size) {
        // Encrypt synchro
        GOST_Crypt_32_E_Cicle(S, GOST_Table, GOST_Key_ptr);
        
#if _GOST_ROT==1
        (*S).half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32((*S).half[_GOST_Data_Part_N2_Half]);
        (*S).half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32((*S).half[_GOST_Data_Part_N1_Half]);
#endif
        
        if (Mode == _GOST_Mode_Encrypt) {
            // Get full block at once
            GOST_Data_Part *Data_ptr = (GOST_Data_Part *)Data;
            GOST_Data_Part Data_tmp = *Data_ptr;
            
            // XOR and update
            Data_tmp.half[0] ^= (*S).half[0];
            Data_tmp.half[1] ^= (*S).half[1];
            
            // Write back and update synchro
            *Data_ptr = Data_tmp;
            *S = Data_tmp;
        } else {
            // Get full block at once
            GOST_Data_Part *Data_ptr = (GOST_Data_Part *)Data;
            GOST_Data_Part Data_tmp = *Data_ptr;
            GOST_Data_Part S_tmp = *S;
            
            // Save for synchro before XOR
            *S = Data_tmp;
            
            // XOR and update
            Data_tmp.half[0] ^= S_tmp.half[0];
            Data_tmp.half[1] ^= S_tmp.half[1];
            
            // Write back
            *Data_ptr = Data_tmp;
        }
        
#if _GOST_ROT==1
        (*S).half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32((*S).half[_GOST_Data_Part_N2_Half]);
        (*S).half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32((*S).half[_GOST_Data_Part_N1_Half]);
#endif
        
        Data += _GOST_Part_Size;
        Size -= _GOST_Part_Size;
    }
    
    // Handle remaining partial block if any
    if (Size > 0) {
        // Encrypt synchro
        GOST_Crypt_32_E_Cicle(S, GOST_Table, GOST_Key_ptr);
        
#if _GOST_ROT==1
        (*S).half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32((*S).half[_GOST_Data_Part_N2_Half]);
        (*S).half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32((*S).half[_GOST_Data_Part_N1_Half]);
#endif
        
        for (uint8_t i = 0; i < Size; i++) {
            if (Mode == _GOST_Mode_Encrypt) {
                *Data ^= (*S).parts[i];
                (*S).parts[i] = *Data;
            } else {
                uint8_t tmp = *Data;
                *Data ^= (*S).parts[i];
                (*S).parts[i] = tmp;
            }
            Data++;
        }
        
#if _GOST_ROT==1
        (*S).half[_GOST_Data_Part_N2_Half] = _GOST_SWAP32((*S).half[_GOST_Data_Part_N2_Half]);
        (*S).half[_GOST_Data_Part_N1_Half] = _GOST_SWAP32((*S).half[_GOST_Data_Part_N1_Half]);
#endif
    }
}
