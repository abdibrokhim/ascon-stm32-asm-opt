#include "main.h"
#include "stm32f1xx_hal.h"
#include "gost28147_89/gost.h"
#include "gost28147_89/gost_opt.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// ASCON headers begin //
#include "api.h"
#if defined(AVR_UART)
#include "avr_uart.h"
#endif
#if defined(CRYPTO_AEAD)
#include "crypto_aead.h"
#elif defined(CRYPTO_HASH)
#include "crypto_hash.h"
#elif defined(CRYPTO_AUTH)
#include "crypto_auth.h"
#endif
#include <stm32f103xb.h>
// ASCON headers end //

// GOST header begin //
#include "gost28147_89/gost.h"
// #include "gost28147_89/gost_opt.h"
// GOST header end //

// Private function prototypes
void print(unsigned char c, unsigned char* x, unsigned long long xlen) {
  unsigned long long i;
  printf("%c[%d]=", c, (int)xlen);
  for (i = 0; i < xlen; ++i) printf("%02x", x[i]);
  printf("\n");
}

// ASCON test function
// int ascon_main() {
//   /* Sample data (key, nonce, associated data, plaintext) */
//   unsigned char n[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
//                            11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
//                            22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
//   unsigned char k[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
//                            11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
//                            22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
//   unsigned char a[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
//                            11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
//                            22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
//   unsigned char m[32] = { 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
//                            11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
//                            22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
//   unsigned char c[32], h[32], t[32];
//   unsigned long long alen = 16;
//   unsigned long long mlen = 16;
//   unsigned long long clen;
//   int result = 0;

// #if defined(AVR_UART)
//   avr_uart_init();
//   stdout = &avr_uart_output;
//   stdin = &avr_uart_input_echo;
// #endif

//   uint32_t total_time = 0;
//   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0);    // LED ON
//     HAL_Delay(5000);                                          // Wait 5 seconds
//     HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1);  // LED OFF
//   uint32_t start_time = HAL_GetTick();
//   for (int i = 0; i < 20000; i++) {

//       result |= crypto_aead_encrypt(c, &clen, m, mlen, a, alen, NULL, n, k);

//   }
//   uint32_t end_time = HAL_GetTick();
//         uint32_t elapsed = end_time - start_time;
//         total_time += elapsed;

//   /* Turn ON LED on PC13, wait 5 seconds, then turn OFF LED */
//   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0);    // LED ON
//   HAL_Delay(5000+result);                                          // Wait 5 seconds
//   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1);  // LED OFF

//   return result;
// }

/* GOST test function */
int gost_main() {
    // Define the 256-bit key (32 bytes)
    uint8_t key[32] = {
        0x04, 0x75, 0xF6, 0xE0, 0x50, 0x38, 0xFB, 0xFA, 
        0xD2, 0xC7, 0xC3, 0x90, 0xED, 0xB3, 0xCA, 0x3D,
        0x15, 0x47, 0x12, 0x42, 0x91, 0xAE, 0x1E, 0x8A, 
        0x2F, 0x79, 0xCD, 0x9E, 0xD2, 0xBC, 0xEF, 0xBD
    };

    // Define a sample S-box (128 bytes, 8 rows of 16 nibbles)
    uint8_t sbox[128] = {
        0x04, 0x02, 0x0F, 0x05, 0x09, 0x01, 0x00, 0x08, 0x0E, 0x03, 0x0B, 0x0C, 0x0D, 0x07, 0x0A, 0x06,
        0x0C, 0x09, 0x0F, 0x0E, 0x08, 0x01, 0x03, 0x0A, 0x02, 0x07, 0x04, 0x0D, 0x06, 0x00, 0x0B, 0x05,
        0x0D, 0x08, 0x0E, 0x0C, 0x07, 0x03, 0x09, 0x0A, 0x01, 0x05, 0x02, 0x04, 0x06, 0x0F, 0x00, 0x0B,
        0x0E, 0x09, 0x0B, 0x02, 0x05, 0x0F, 0x07, 0x01, 0x00, 0x0D, 0x0C, 0x06, 0x0A, 0x04, 0x03, 0x08,
        0x03, 0x0E, 0x05, 0x09, 0x06, 0x08, 0x00, 0x0D, 0x0A, 0x0B, 0x07, 0x0C, 0x02, 0x01, 0x0F, 0x04,
        0x08, 0x0F, 0x06, 0x0B, 0x01, 0x09, 0x0C, 0x05, 0x0D, 0x03, 0x07, 0x0A, 0x00, 0x0E, 0x02, 0x04,
        0x09, 0x0B, 0x0C, 0x00, 0x03, 0x06, 0x07, 0x05, 0x04, 0x08, 0x0E, 0x0F, 0x01, 0x0A, 0x02, 0x0D,
        0x0C, 0x06, 0x05, 0x02, 0x0B, 0x00, 0x09, 0x0D, 0x03, 0x0E, 0x07, 0x0A, 0x0F, 0x04, 0x01, 0x08
    };

    // Test data (64 bytes - multiple blocks)
    uint8_t test_data[64];
    
    // Initialize test data
    for (int i = 0; i < sizeof(test_data); i++) {
        test_data[i] = i & 0xFF;
    }

    // Performance measurement variables
    uint32_t iterations = 20000;
    uint32_t start_time, end_time, elapsed;
    
    // Signal start of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(5000); // Wait 3 seconds
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    
    // Measure time for original GOST implementation
    start_time = HAL_GetTick();
    for (uint32_t i = 0; i < iterations; i++) {
        GOST_Encrypt_SR(test_data, 8, _GOST_Mode_Encrypt, sbox, key);
    }
    end_time = HAL_GetTick();
    elapsed = end_time - start_time;
    
    // Signal end of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(1000);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    
    // Flash LED to indicate elapsed time (in seconds)
    uint32_t elapsed_seconds = elapsed / 1000;
    if (elapsed_seconds == 0) elapsed_seconds = 1;
    
    HAL_Delay(2000); // Pause before blinking
    
    for (uint32_t i = 0; i < elapsed_seconds; i++) {
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
        HAL_Delay(200);
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
        HAL_Delay(200);
    }
    
    return elapsed;
}

/* GOST test function */
// Optimized GOST
int gost_opt_main() {
    // Define the 256-bit key (32 bytes) - SAME AS gost_main()
    uint8_t key[32] = {
        0x04, 0x75, 0xF6, 0xE0, 0x50, 0x38, 0xFB, 0xFA, 
        0xD2, 0xC7, 0xC3, 0x90, 0xED, 0xB3, 0xCA, 0x3D,
        0x15, 0x47, 0x12, 0x42, 0x91, 0xAE, 0x1E, 0x8A, 
        0x2F, 0x79, 0xCD, 0x9E, 0xD2, 0xBC, 0xEF, 0xBD
    };

    // Define a sample S-box (128 bytes, 8 rows of 16 nibbles) - SAME AS gost_main()
    uint8_t sbox[128] = {
        0x04, 0x02, 0x0F, 0x05, 0x09, 0x01, 0x00, 0x08, 0x0E, 0x03, 0x0B, 0x0C, 0x0D, 0x07, 0x0A, 0x06,
        0x0C, 0x09, 0x0F, 0x0E, 0x08, 0x01, 0x03, 0x0A, 0x02, 0x07, 0x04, 0x0D, 0x06, 0x00, 0x0B, 0x05,
        0x0D, 0x08, 0x0E, 0x0C, 0x07, 0x03, 0x09, 0x0A, 0x01, 0x05, 0x02, 0x04, 0x06, 0x0F, 0x00, 0x0B,
        0x0E, 0x09, 0x0B, 0x02, 0x05, 0x0F, 0x07, 0x01, 0x00, 0x0D, 0x0C, 0x06, 0x0A, 0x04, 0x03, 0x08,
        0x03, 0x0E, 0x05, 0x09, 0x06, 0x08, 0x00, 0x0D, 0x0A, 0x0B, 0x07, 0x0C, 0x02, 0x01, 0x0F, 0x04,
        0x08, 0x0F, 0x06, 0x0B, 0x01, 0x09, 0x0C, 0x05, 0x0D, 0x03, 0x07, 0x0A, 0x00, 0x0E, 0x02, 0x04,
        0x09, 0x0B, 0x0C, 0x00, 0x03, 0x06, 0x07, 0x05, 0x04, 0x08, 0x0E, 0x0F, 0x01, 0x0A, 0x02, 0x0D,
        0x0C, 0x06, 0x05, 0x02, 0x0B, 0x00, 0x09, 0x0D, 0x03, 0x0E, 0x07, 0x0A, 0x0F, 0x04, 0x01, 0x08
    };

    // Create optimized substitution table
    GOST_Subst_Table subst_table;
    for(int i = 0; i < 4; i++) {
        uint8_t* sbox_low = sbox + (i * 2) * 16;
        uint8_t* sbox_high = sbox + (i * 2 + 1) * 16;
        
        for(int b = 0; b < 256; b++) {
            uint8_t low_nibble = b & 0x0F;
            uint8_t high_nibble = (b >> 4) & 0x0F;
            uint8_t low_subst = sbox_low[low_nibble];
            uint8_t high_subst = sbox_high[high_nibble];
            subst_table[i*256 + b] = low_subst | (high_subst << 4);
        }
    }

    // Test data (identical to gost_main)
    uint8_t test_data[64];
    
    // Initialize test data (identical to gost_main)
    for (int i = 0; i < sizeof(test_data); i++) {
        test_data[i] = i & 0xFF;
    }
    
    // Performance measurement variables
    uint32_t iterations = 20000;
    uint32_t start_time, end_time, elapsed;
    
    // Signal start of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(5000); // Wait 3 seconds
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF

    // Measure performance
    start_time = HAL_GetTick();
    for (uint32_t i = 0; i < iterations; i++) {
        GOST_Encrypt_SR_Opt(test_data, 8, _GOST_Mode_Encrypt, subst_table, key);
    }
    end_time = HAL_GetTick();
    elapsed = end_time - start_time;
    
    // Signal end of benchmark
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(1000);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    
    // Flash LED to indicate elapsed time (in seconds)
    uint32_t elapsed_seconds = elapsed / 1000;
    if (elapsed_seconds == 0) elapsed_seconds = 1;
    
    HAL_Delay(2000); // Pause before blinking
    
    for (uint32_t i = 0; i < elapsed_seconds; i++) {
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
        HAL_Delay(200);
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
        HAL_Delay(200);
    }

    return elapsed;
}


/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
TIM_HandleTypeDef htim1;

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_TIM1_Init(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_TIM1_Init();
  /* USER CODE BEGIN 2 */

  /* USER CODE END 2 */

  /* ASCON CODE BEGIN */
  // ascon_main();
  /* ASCON CODE END */

  /* GOST CODE BEGIN */
  // Original GOST
  uint32_t orig_time = gost_main(); // it took 04:49 secs
  /* GOST CODE END */

  /* GOST CODE BEGIN */
  // Optimized GOST
  uint32_t opt_time = gost_opt_main(); // it took 02:27 secs
  /* GOST CODE END */

  // Show performance comparison
  HAL_Delay(3000); // Pause before final results

  // Calculate performance improvement ratio
  float improvement = 0;
  if (opt_time > 0) {
    improvement = (float)orig_time / opt_time;
  }

  // Display results through LED blinks
  // First: Original time (1 blink per second)
  // Second: Optimized time (1 blink per second)
  // Third: Performance ratio (number of blinks indicates improvement factor)
  
  // Display the improvement factor
  int blinks = 0;
  if (improvement >= 1.0f) {
    blinks = (int)improvement;
    if (blinks < 1) blinks = 1;
    if (blinks > 10) blinks = 10; // Cap at 10 blinks
    
    // Rapid blinks indicate speedup factor
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
    HAL_Delay(1000);
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
    HAL_Delay(1000);
    
    for (int i = 0; i < blinks; i++) {
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
      HAL_Delay(100);
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
      HAL_Delay(100);
    }
  } else {
    // Slow blinks indicate slowdown (optimization failed)
    for (int i = 0; i < 3; i++) {
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0); // LED ON
      HAL_Delay(1000);
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1); // LED OFF
      HAL_Delay(1000);
    }
  }

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
	   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 1);
	   HAL_Delay(1000);
	   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, 0);
	   HAL_Delay(1000);
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_NONE;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief TIM1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM1_Init(void)
{

  /* USER CODE BEGIN TIM1_Init 0 */

  /* USER CODE END TIM1_Init 0 */

  TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};

  /* USER CODE BEGIN TIM1_Init 1 */

  /* USER CODE END TIM1_Init 1 */
  htim1.Instance = TIM1;
  htim1.Init.Prescaler = 0;
  htim1.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim1.Init.Period = 65535;
  htim1.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim1.Init.RepetitionCounter = 0;
  htim1.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim1) != HAL_OK)
  {
    Error_Handler();
  }
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  if (HAL_TIM_ConfigClockSource(&htim1, &sClockSourceConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim1, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM1_Init 2 */

  /* USER CODE END TIM1_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
/* USER CODE BEGIN MX_GPIO_Init_1 */
/* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);

  /*Configure GPIO pin : PC13 */
  GPIO_InitStruct.Pin = GPIO_PIN_13;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

/* USER CODE BEGIN MX_GPIO_Init_2 */
/* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
