# Task
The task is to develop a mean filter algorithm using VHDL and Basys3 FPGA. 
The mean filter is capable of removing the noise from an image by blurring the image. A 3x3 kernel is used for this implementation. The kernel will be moving through the image. During the moving, the average value of the pixels of the image which are covered by the kernel will be calculated. Then the pixel value of the center pixel at that instance will be replaced with the calculated average value. This image transformation reduces the noise of the image and smooths the image.

![alt text](https://miro.medium.com/max/894/1*NtJRHLs24yeEzz23yl_5Pg.png?raw=true)

# Design
## Top Module
The high level architecture of the system is as follows.
![alt text](https://github.com/bhanukad610/HDL-project/blob/master/Images/top_module.png?raw=true)

## Scheduler
### Module description
The main task of the scheduler is to manage each component. The scheduler initiates the process from the user input. To initiate the process, a flag from the UART handler should be raised that says there are enough pixel values that are loaded to the first BRAM. Then the scheduler gives row and column to the mean filter that needs to calculate. Furthermore, scheduler tells UART handler to send to the resulted image after finishing the process

### Module overview 

## Mean Filter
### Module description
Mean filter module is used for the purpose of calculating the pixel value of a given pixel of the final image. Row and column values are given as 5 bit values with address of the memory location of the output BRAM component.
Here a 3x3 kernel is used for the convolution.

![alt text](https://miro.medium.com/max/255/1*wJfPULU0I_OnskXTkWjqkA.gif?raw=true)

Then respective 9 pixel values are retrieved from the input BRAM. For that first need to calculate the memory location of the pixel value as here the input image is considered as 1D array. For that below formula is used.
col_offset and row_offset variables are used for the purpose of implementing a for loop. Both variables are initialized as -1 and it loops until row_offset gets value 1. 
Calculated address value is used to get the pixel value and added to a global variable sum. 
Final value for the output image is gained by dividing it by 9 which is the kernel size. Then it is sent to the output bram with the address of the output BRAM.

![alt text](https://github.com/bhanukad610/HDL-project/blob/master/Images/equation.png?raw=true)
col_offset and row_offset variables are used for the purpose of implementing a for loop. Both variables are initialized as -1 and it loops until row_offset gets value 1. 
Calculated address value is used to get the pixel value and added to a global variable sum. 
Final value for the output image is gained by dividing it by 9 which is the kernel size. Then it is sent to the output bram with the address of the output BRAM.
### Module overview 
![alt text](https://github.com/bhanukad610/HDL-project/blob/master/Images/mean_filter.png?raw=true)

## BRAM
### Component Description
2 BRAMs are used. One is to store the input image pixel values after adding the padding. And second one for storing the output image’s pixel values.
### Component Overview
![alt text](https://github.com/bhanukad610/HDL-project/blob/master/Images/BRam_2.PNG?raw=true)

## UART Lite
### Component Description
UART lite IP core has four registers

| Address Offset  | Register Name | Description |
| -------------   | ------------- | ---------- |
| 0h | Rx FIFO | Receive data FIFO |
| 04h | Tx FIFO | Transmit data FIFO |
| 08h | STAT_REG| UART Lite status register |
| 0Ch | CTRL_REG | UART Lite control register |

UART Communication is achieved by doing read operations and write operations to the above four registers. The read operations and write operations are done using AXI protocol which is a protocol used to communicate in networks on chip systems. Properties of each register will be described as follows.

### Component Overview 
![alt text](https://github.com/bhanukad610/HDL-project/blob/master/Images/UARTLite.PNG?raw=true)

## UART Handler
### Component Description
UART handlers receive the input image from the Rx line and load the input image to the first BRAM. Then after finishing the whole process BRAM sends the resulting image to the Tx line.
### Component Overview
![alt text](https://github.com/bhanukad610/HDL-project/blob/master/Images/uart_handler.png?raw=true)

