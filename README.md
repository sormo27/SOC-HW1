# SoC_HW1_C110112127
# FPGA LED 跑馬燈專案_AXI4Lite練習題

## 專案概述

本專案使用 FPGA 實現硬體讀取開關狀態、軟體控制 LED 燈效果，並透開關控制顯示模式。

## 功能

- **SW0：** 跑馬燈向左（每次往左 shift 一位）
- **SW1：** 跑馬燈向右（每次往右 shift 一位）
- **SW2：** 呼吸燈效果：漸亮（breathe++）
- **SW3：** 閃爍效果（toggle 在全亮與全暗之間切換）
- **SW4：** 奇數 LED 亮（10101010）
- **SW5：** 偶數 LED 亮（01010101）
- **SW6：** 反向呼吸：漸暗（breathe--）
- **SW7：** 強制全亮（優先度最高）

## 硬體

- **開發板：** EGO-XZ7（Zynq-7000 SoC，型號：XC7Z020CLG484-1）
- **處理器：** ARM Cortex-A9
- **LED：** 展示跑馬燈效果
- **按鈕：** 用於控制跑馬燈的速度
- **開關：** 用於反轉 LED 顯示

## 軟體工具

- **Xilinx Vivado 2018：** 用於硬體設計與合成。
- **Xilinx SDK：** 用於開發軟體並控制 PS。

## Block Design 圖

![Block Design 圖](img\Block Design 圖.png)
## 示範影片連結
[👉 點我觀看影片](https://youtu.be/EJHje2ceJPk?si=HODhzvzEDTRMRPkG)






