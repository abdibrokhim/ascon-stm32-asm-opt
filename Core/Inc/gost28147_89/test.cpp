// #include <string.h>
// #include "gost.h"


// uint8_t Gost_Table[_GOST_TABLE_SIZE] = {
//     0x04, 0x02, 0x0F, 0x05, 0x09, 0x01, 0x00, 0x08, 0x0E, 0x03, 0x0B, 0x0C, 0x0D, 0x07, 0x0A, 0x06,
//     0x0C, 0x09, 0x0F, 0x0E, 0x08, 0x01, 0x03, 0x0A, 0x02, 0x07, 0x04, 0x0D, 0x06, 0x00, 0x0B, 0x05,
//     0x0D, 0x08, 0x0E, 0x0C, 0x07, 0x03, 0x09, 0x0A, 0x01, 0x05, 0x02, 0x04, 0x06, 0x0F, 0x00, 0x0B,
//     0x0E, 0x09, 0x0B, 0x02, 0x05, 0x0F, 0x07, 0x01, 0x00, 0x0D, 0x0C, 0x06, 0x0A, 0x04, 0x03, 0x08,
//     0x03, 0x0E, 0x05, 0x09, 0x06, 0x08, 0x00, 0x0D, 0x0A, 0x0B, 0x07, 0x0C, 0x02, 0x01, 0x0F, 0x04,
//     0x08, 0x0F, 0x06, 0x0B, 0x01, 0x09, 0x0C, 0x05, 0x0D, 0x03, 0x07, 0x0A, 0x00, 0x0E, 0x02, 0x04,
//     0x09, 0x0B, 0x0C, 0x00, 0x03, 0x06, 0x07, 0x05, 0x04, 0x08, 0x0E, 0x0F, 0x01, 0x0A, 0x02, 0x0D,
//     0x0C, 0x06, 0x05, 0x02, 0x0B, 0x00, 0x09, 0x0D, 0x03, 0x0E, 0x07, 0x0A, 0x0F, 0x04, 0x01, 0x08
// };
// uint8_t GOST_Key_d[_GOST_Key_Size] = {
//         0x04, 0x75, 0xF6, 0xE0, 0x50, 0x38, 0xFB, 0xFA, 0xD2, 0xC7, 0xC3, 0x90, 0xED, 0xB3, 0xCA, 0x3D,
//         0x15, 0x47, 0x12, 0x42, 0x91, 0xAE, 0x1E, 0x8A, 0x2F, 0x79, 0xCD, 0x9E, 0xD2, 0xBC, 0xEF, 0xBD
// };
// uint8_t Data_O[24] = {
//     0x6A, 0xDB, 0x6E, 0xC5, 0x3E, 0xC6, 0x45, 0xA4, 0x70, 0xA8, 0x22, 0xB8, 0x94, 0xA7, 0xFE, 0x28,
//     0x38, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
// };
// //Data from real etalon cryptor:
// //imitta
// uint8_t Imitta_Et[_GOST_Imitta_Size] ={
//         0xD9, 0x8F, 0xEB, 0x04, 0x81, 0xF6, 0x2C, 0x41
// };
// #if _GOST_ROT_Synchro_GAMMA==1
// //synchro
// uint8_t Synchro_Et[_GOST_Synchro_Size] =
// {
//     0xC3, 0xA7,0x80, 0x2A, 0x47, 0xE3, 0xA8, 0xFF
// };
// #else
// uint8_t Synchro_Et[_GOST_Synchro_Size] =
// {
//    0x47, 0xE3, 0xA8, 0xFF, 0xC3, 0xA7,0x80, 0x2A
// };
// #endif
// //Simple replacement
// uint8_t Data_C_S_Et[24] = {
//     0x12, 0xA2, 0x8E, 0x60, 0x5D, 0x76, 0xBF, 0xC9, 0xAF, 0x84, 0x67, 0x8A, 0xA5, 0xE8, 0xF7, 0xE8,
//     0xDE, 0x8E, 0x29, 0x16, 0x19, 0xCB, 0xD2, 0x08
// };
// //Gamma
// unsigned char Data_C_G_Et[24] = {
//     0x8B, 0x39, 0x76, 0x8B, 0x52, 0xE3, 0x94, 0x1D, 0xEA, 0x22, 0xC7, 0x24, 0x86, 0x56, 0xA2, 0xCE,
//     0x11, 0x61, 0xF0, 0x07, 0x4B, 0xF8, 0xCA, 0x00
// };
// //Gamma with feedback
// unsigned char Data_C_GF_Et[24] = {
//     0x20, 0x36, 0xB4, 0x76, 0x29, 0x44, 0x36, 0xDE, 0xF1, 0x17, 0x0F, 0x02, 0x82, 0x40, 0x00, 0x05,
//     0xEC, 0x04, 0x87, 0xBB, 0xF4, 0x46, 0x0A, 0xA2
// };



// uint8_t  Imitta[_GOST_Imitta_Size];
// uint8_t  Data_E[sizeof(Data_O)];
// uint8_t  Synchro[_GOST_Synchro_Size];
// int main(int argc, char *argv[])
// {
//     QCoreApplication a(argc, argv);
// //Imitta test
//     memset(Imitta,_GOST_Def_Byte,_GOST_Imitta_Size);
//     GOST_Imitta(Data_O, Imitta, sizeof(Data_O),Gost_Table,GOST_Key_d);
//     if (memcmp(Imitta,Imitta_Et,_GOST_Imitta_Size))
//     {
//         printf("Imitta test failed\r\n");
//     } else
//     {
//         printf("Imitta test passed\r\n");
//     }
// //Simple replacement
//     memcpy(Data_E,Data_O,sizeof(Data_O));
//     GOST_Encrypt_SR(Data_E,sizeof(Data_E),_GOST_Mode_Encrypt,Gost_Table,GOST_Key_d);
//     if (memcmp(Data_C_S_Et,Data_E,sizeof(Data_E)))
//     {
//         printf("Simple replacement encryption test failed\r\n");
//     } else
//     {
//         printf("Simple replacement encryption test passed\r\n");
//     }
//     GOST_Encrypt_SR(Data_E,sizeof(Data_E),_GOST_Mode_Decrypt,Gost_Table,GOST_Key_d);
//     if (memcmp(Data_O,Data_E,sizeof(Data_E)))
//     {
//         printf("Simple replacement decryption test failed\r\n");
//     } else
//     {
//         printf("Simple decryption test passed\r\n");
//     }
// //Gamma
//     memcpy(Data_E,Data_O,sizeof(Data_O));
//     memcpy(Synchro,Synchro_Et,sizeof(Synchro));
//     GOST_Crypt_G_PS(Synchro,Gost_Table,GOST_Key_d);//Decrypt Synchro acording to standart
//     GOST_Crypt_G_Data(Data_E,sizeof(Data_E),Synchro,Gost_Table,GOST_Key_d);
//     if (memcmp(Data_E,Data_C_G_Et,sizeof(Data_E)))
//     {
//         printf("Gamma encryption test failed\r\n");
//     } else
//     {
//         printf("Gamma encryption test passed\r\n");
//     }

//     memcpy(Synchro,Synchro_Et,sizeof(Synchro));
//     GOST_Crypt_G_PS(Synchro,Gost_Table,GOST_Key_d);//Decrypt Synchro acording to standart
//     GOST_Crypt_G_Data(Data_E,sizeof(Data_E),Synchro,Gost_Table,GOST_Key_d);
//     if (memcmp(Data_O,Data_E,sizeof(Data_E)))
//     {
//         printf("Gamma decryption test failed\r\n");
//     } else
//     {
//         printf("Gamma decryption test passed\r\n");
//     }
// //Gamma with feedback
//     memcpy(Synchro,Synchro_Et,sizeof(Synchro));
//     memcpy(Data_E,Data_O,sizeof(Data_O));
// #if _GOST_ROT_Synchro_GAMMA==1
//     GOST_Crypt_GF_Prepare_S(Synchro);
// #endif
//     GOST_Crypt_GF_Data(Data_E,sizeof(Data_E),Synchro,_GOST_Mode_Encrypt,Gost_Table,GOST_Key_d);
//     if (memcmp(Data_E,Data_C_GF_Et,sizeof(Data_E)))
//     {
//         printf("Gamma with feedback encryption test failed\r\n");
//     } else
//     {
//        printf("Gamma with feedback encryption test passed\r\n");
//     }
//     memcpy(Synchro,Synchro_Et,sizeof(Synchro));
// #if _GOST_ROT_Synchro_GAMMA==1
//     GOST_Crypt_GF_Prepare_S(Synchro);
// #endif
//     GOST_Crypt_GF_Data(Data_E,sizeof(Data_E),Synchro,_GOST_Mode_Decrypt,Gost_Table,GOST_Key_d);
//     if (memcmp(Data_O,Data_E,sizeof(Data_E)))
//     {
//         printf("Gamma with feedback decryption test failed\r\n");
//     } else
//     {
//        printf("Gamma with feedback decryption test passed\r\n");
//     }
//     return 0;
// }