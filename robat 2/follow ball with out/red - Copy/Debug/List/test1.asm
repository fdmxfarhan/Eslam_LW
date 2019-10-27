
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _cmp=R4
	.DEF _cmp_msb=R5
	.DEF _i=R6
	.DEF _i_msb=R7
	.DEF _adc_min=R8
	.DEF _adc_min_msb=R9
	.DEF _shl=R10
	.DEF _shl_msb=R11
	.DEF _shb=R12
	.DEF _shb_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 24/10/2019
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8/000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;int cmp,i,adc[16],adc_min,shl,shb,shr,e,kr,kf,kl,kb;
;
;eeprom int c,sr,sb,sl,sf;
;// I2C Bus functions
;#include <i2c.h>
;#define EEPROM_BUS_ADDRES 0xc0
;/* read/ a byte from the EEPROM */
;unsigned char compass_read(unsigned char addres)
; 0000 0024  {

	.CSEG
_compass_read:
; .FSTART _compass_read
; 0000 0025     unsigned char data;
; 0000 0026     delay_us(100);
	ST   -Y,R26
	ST   -Y,R17
;	addres -> Y+1
;	data -> R17
	CALL SUBOPT_0x0
; 0000 0027     i2c_start();
	CALL _i2c_start
; 0000 0028     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0029     i2c_write(EEPROM_BUS_ADDRES);
	LDI  R26,LOW(192)
	CALL SUBOPT_0x1
; 0000 002A     delay_us(100);
; 0000 002B     i2c_write(addres);
	LDD  R26,Y+1
	CALL SUBOPT_0x1
; 0000 002C     delay_us(100);
; 0000 002D     i2c_start();
	CALL _i2c_start
; 0000 002E     delay_us(100);
	CALL SUBOPT_0x0
; 0000 002F     i2c_write(EEPROM_BUS_ADDRES | 1);
	LDI  R26,LOW(193)
	CALL SUBOPT_0x1
; 0000 0030     delay_us(100);
; 0000 0031     data=i2c_read(0);
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R17,R30
; 0000 0032     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0033     i2c_stop();
	CALL _i2c_stop
; 0000 0034     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0035     return data;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2020002
; 0000 0036  }
; .FEND
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0042 {
_read_adc:
; .FSTART _read_adc
; 0000 0043 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0044 // Delay needed for the stabilization of the ADC input voltage
; 0000 0045 delay_us(10);
	__DELAY_USB 27
; 0000 0046 // Start the AD conversion
; 0000 0047 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0048 // Wait for the AD conversion to complete
; 0000 0049 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 004A ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 004B return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2020001
; 0000 004C }
; .FEND
;
;void read_cmp()
; 0000 004F {
_read_cmp:
; .FSTART _read_cmp
; 0000 0050  cmp=compass_read(1)-c;
	LDI  R26,LOW(1)
	RCALL _compass_read
	MOV  R0,R30
	CLR  R1
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	CALL SUBOPT_0x2
	MOVW R4,R26
; 0000 0051 
; 0000 0052           if (cmp<0) cmp=cmp+255;
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x6
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	MOVW R4,R30
; 0000 0053           if (cmp>128) cmp=cmp-255;
_0x6:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x7
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 4,5,30,31
; 0000 0054           if (cmp<128) cmp=cmp;
_0x7:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x8
	MOVW R4,R4
; 0000 0055 
; 0000 0056           if(cmp>=0)
_0x8:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRLT _0x9
; 0000 0057           {
; 0000 0058               lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x3
; 0000 0059               lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL _lcd_putchar
; 0000 005A               lcd_putchar((cmp/100)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x4
; 0000 005B               lcd_putchar((cmp/10)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x5
; 0000 005C               lcd_putchar((cmp/1)%10+'0');
	MOVW R26,R4
	RJMP _0x9C
; 0000 005D           }
; 0000 005E           else if(cmp<0)
_0x9:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0xB
; 0000 005F           {
; 0000 0060               lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x3
; 0000 0061               lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 0062               lcd_putchar((-1*cmp/100)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x4
; 0000 0063               lcd_putchar((-1*cmp/10)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x5
; 0000 0064               lcd_putchar((-1*cmp/1)%10+'0');
	CALL SUBOPT_0x6
_0x9C:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x7
; 0000 0065           }
; 0000 0066 
; 0000 0067 }
_0xB:
	RET
; .FEND
;void read_sensor()
; 0000 0069 {
_read_sensor:
; .FSTART _read_sensor
; 0000 006A  for(i=0;i<16;i++)
	CLR  R6
	CLR  R7
_0xD:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R6,R30
	CPC  R7,R31
	BRLT PC+2
	RJMP _0xE
; 0000 006B  {
; 0000 006C       PORTB.4=(i/1)%2;
	MOVW R30,R6
	CALL SUBOPT_0x8
	BRNE _0xF
	CBI  0x18,4
	RJMP _0x10
_0xF:
	SBI  0x18,4
_0x10:
; 0000 006D       PORTB.5=(i/2)%2;
	MOVW R26,R6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x9
	BRNE _0x11
	CBI  0x18,5
	RJMP _0x12
_0x11:
	SBI  0x18,5
_0x12:
; 0000 006E       PORTB.6=(i/4)%2;
	MOVW R26,R6
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x9
	BRNE _0x13
	CBI  0x18,6
	RJMP _0x14
_0x13:
	SBI  0x18,6
_0x14:
; 0000 006F       PORTB.7=(i/8)%2;
	MOVW R26,R6
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x9
	BRNE _0x15
	CBI  0x18,7
	RJMP _0x16
_0x15:
	SBI  0x18,7
_0x16:
; 0000 0070       adc[i]=read_adc(0);
	MOVW R30,R6
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(0)
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0071       if(adc[i]<adc[adc_min]) adc_min=i;
	MOVW R30,R6
	CALL SUBOPT_0xA
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	MOVW R30,R8
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CP   R0,R30
	CPC  R1,R31
	BRGE _0x17
	MOVW R8,R6
; 0000 0072       }
_0x17:
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0xD
_0xE:
; 0000 0073       lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 0074       lcd_putchar((adc_min/10)%10+'0');
	MOVW R26,R8
	CALL SUBOPT_0x5
; 0000 0075       lcd_putchar((adc_min/1)%10+'0');
	MOVW R26,R8
	CALL SUBOPT_0xC
; 0000 0076       lcd_putchar(':');
	LDI  R26,LOW(58)
	CALL _lcd_putchar
; 0000 0077       lcd_putchar((adc[adc_min]/1000)%10+'0');
	MOVW R30,R8
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	MOVW R26,R30
	CALL SUBOPT_0xC
; 0000 0078       lcd_putchar((adc[adc_min]/100)%10+'0');
	MOVW R30,R8
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	MOVW R26,R30
	CALL SUBOPT_0x4
; 0000 0079       lcd_putchar((adc[adc_min]/10)%10+'0');
	MOVW R30,R8
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	MOVW R26,R30
	CALL SUBOPT_0x5
; 0000 007A       lcd_putchar((adc[adc_min]/1)%10+'0');
	MOVW R30,R8
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	MOVW R26,R30
	CALL SUBOPT_0xC
; 0000 007B 
; 0000 007C 
; 0000 007D 
; 0000 007E 
; 0000 007F        //-------------------sharp left
; 0000 0080        shl=read_adc(1);
	LDI  R26,LOW(1)
	RCALL _read_adc
	MOVW R10,R30
; 0000 0081 
; 0000 0082        lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xD
; 0000 0083 
; 0000 0084        lcd_putchar((shl/100)%10+'0');
	MOVW R26,R10
	CALL SUBOPT_0x4
; 0000 0085 
; 0000 0086        lcd_putchar((shl/10)%10+'0');
	MOVW R26,R10
	CALL SUBOPT_0x5
; 0000 0087 
; 0000 0088        lcd_putchar((shl/1)%10+'0');
	MOVW R26,R10
	CALL SUBOPT_0xC
; 0000 0089         //-------------------sharp back
; 0000 008A 
; 0000 008B        shb=read_adc(2);
	LDI  R26,LOW(2)
	RCALL _read_adc
	MOVW R12,R30
; 0000 008C 
; 0000 008D        lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xD
; 0000 008E 
; 0000 008F        lcd_putchar((shb/100)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x4
; 0000 0090 
; 0000 0091        lcd_putchar((shb/10)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x5
; 0000 0092 
; 0000 0093        lcd_putchar((shb/1)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0xC
; 0000 0094        //-------------------sharp right
; 0000 0095 
; 0000 0096        shr=read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	STS  _shr,R30
	STS  _shr+1,R31
; 0000 0097 
; 0000 0098        lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xD
; 0000 0099 
; 0000 009A        lcd_putchar((shr/100)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0x4
; 0000 009B 
; 0000 009C        lcd_putchar((shr/10)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0x5
; 0000 009D 
; 0000 009E        lcd_putchar((shr/1)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
; 0000 009F 
; 0000 00A0         //-------------------kfR
; 0000 00A1 
; 0000 00A2     kr=read_adc(4)-sr;
	LDI  R26,LOW(4)
	RCALL _read_adc
	MOVW R0,R30
	LDI  R26,LOW(_sr)
	LDI  R27,HIGH(_sr)
	CALL SUBOPT_0x2
	STS  _kr,R26
	STS  _kr+1,R27
; 0000 00A3 
; 0000 00A4     lcd_gotoxy(13,0);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x3
; 0000 00A5 
; 0000 00A6     lcd_putchar((kr/100)%10+'0');
	CALL SUBOPT_0xF
	CALL SUBOPT_0x4
; 0000 00A7 
; 0000 00A8     lcd_putchar((kr/10)%10+'0');
	CALL SUBOPT_0xF
	CALL SUBOPT_0x5
; 0000 00A9 
; 0000 00AA    // lcd_putchar((kr/1)%10+'0');
; 0000 00AB 
; 0000 00AC    //-----------------------kfBack
; 0000 00AD     kb=read_adc(5)-sb;
	LDI  R26,LOW(5)
	RCALL _read_adc
	MOVW R0,R30
	LDI  R26,LOW(_sb)
	LDI  R27,HIGH(_sb)
	CALL SUBOPT_0x2
	STS  _kb,R26
	STS  _kb+1,R27
; 0000 00AE 
; 0000 00AF     lcd_gotoxy(11,1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0xD
; 0000 00B0 
; 0000 00B1     lcd_putchar((kb/100)%10+'0');
	CALL SUBOPT_0x10
	CALL SUBOPT_0x4
; 0000 00B2 
; 0000 00B3     lcd_putchar((kb/10)%10+'0');
	CALL SUBOPT_0x10
	CALL SUBOPT_0x5
; 0000 00B4 
; 0000 00B5     //lcd_putchar((kr/1)%10+'0');
; 0000 00B6 
; 0000 00B7    //-----------------------kfLeft
; 0000 00B8     kl=read_adc(6)-sl;
	LDI  R26,LOW(6)
	RCALL _read_adc
	MOVW R0,R30
	LDI  R26,LOW(_sl)
	LDI  R27,HIGH(_sl)
	CALL SUBOPT_0x2
	STS  _kl,R26
	STS  _kl+1,R27
; 0000 00B9 
; 0000 00BA     lcd_gotoxy(14,1);
	LDI  R30,LOW(14)
	CALL SUBOPT_0xD
; 0000 00BB 
; 0000 00BC     lcd_putchar((kl/100)%10+'0');
	CALL SUBOPT_0x11
	CALL SUBOPT_0x4
; 0000 00BD 
; 0000 00BE     lcd_putchar((kl/10)%10+'0');
	CALL SUBOPT_0x11
	CALL SUBOPT_0x5
; 0000 00BF 
; 0000 00C0   //  lcd_putchar((kl/1)%10+'0');
; 0000 00C1 
; 0000 00C2     //-----------------------kfFront
; 0000 00C3     kf=read_adc(7)-sf;
	LDI  R26,LOW(7)
	RCALL _read_adc
	MOVW R0,R30
	LDI  R26,LOW(_sf)
	LDI  R27,HIGH(_sf)
	CALL SUBOPT_0x2
	STS  _kf,R26
	STS  _kf+1,R27
; 0000 00C4 
; 0000 00C5     lcd_gotoxy(10,0);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x3
; 0000 00C6 
; 0000 00C7     lcd_putchar((kf/100)%10+'0');
	CALL SUBOPT_0x12
	CALL SUBOPT_0x4
; 0000 00C8 
; 0000 00C9     lcd_putchar((kf/10)%10+'0');
	CALL SUBOPT_0x12
	CALL SUBOPT_0x5
; 0000 00CA 
; 0000 00CB    // lcd_putchar((kr/1)%10+'0');
; 0000 00CC 
; 0000 00CD 
; 0000 00CE 
; 0000 00CF        e=(shr-shl);
	LDS  R30,_shr
	LDS  R31,_shr+1
	SUB  R30,R10
	SBC  R31,R11
	STS  _e,R30
	STS  _e+1,R31
; 0000 00D0  }
	RET
; .FEND
;
; void motor(int ml1,int ml2,int mr2,int mr1)
; 0000 00D3  {
_motor:
; .FSTART _motor
; 0000 00D4 
; 0000 00D5      ml1+=cmp;
	ST   -Y,R27
	ST   -Y,R26
;	ml1 -> Y+6
;	ml2 -> Y+4
;	mr2 -> Y+2
;	mr1 -> Y+0
	MOVW R30,R4
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00D6      ml2+=cmp;
	MOVW R30,R4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00D7      mr2+=cmp;
	MOVW R30,R4
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00D8      mr1+=cmp;
	MOVW R30,R4
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 00D9 
; 0000 00DA      if(ml1>255)  ml1=255;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x18
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00DB      if(ml1<-255) ml1=-255;
_0x18:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x19
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00DC 
; 0000 00DD      if(ml2>255)  ml2=255;
_0x19:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1A
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00DE      if(ml2<-255) ml2=-255;
_0x1A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x1B
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00DF 
; 0000 00E0      if(mr2>255)  mr2=255;
_0x1B:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1C
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00E1      if(mr2<-255) mr2=-255;
_0x1C:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x1D
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00E2 
; 0000 00E3      if(mr1>255)  mr1=255;
_0x1D:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1E
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00E4      if(mr1<-255) mr1=-255;
_0x1E:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x1F
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00E5 
; 0000 00E6     //------------------------------ML1
; 0000 00E7 
; 0000 00E8        if(ml1>0)
_0x1F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BRGE _0x20
; 0000 00E9        {
; 0000 00EA        PORTD.3=0;
	CBI  0x12,3
; 0000 00EB        OCR2=ml1;
	LDD  R30,Y+6
	RJMP _0x9D
; 0000 00EC        }
; 0000 00ED        else if(ml1<=0)
_0x20:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BRLT _0x24
; 0000 00EE        {
; 0000 00EF        PORTD.3=1 ;
	SBI  0x12,3
; 0000 00F0        OCR2=ml1+255;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
_0x9D:
	OUT  0x23,R30
; 0000 00F1        }
; 0000 00F2 
; 0000 00F3        //ML2
; 0000 00F4        if(ml2>0)
_0x24:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __CPW02
	BRGE _0x27
; 0000 00F5        {
; 0000 00F6        PORTD.2=0;
	CBI  0x12,2
; 0000 00F7        OCR1A=ml2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x9E
; 0000 00F8        }
; 0000 00F9        else if(ml2<=0)
_0x27:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __CPW02
	BRLT _0x2B
; 0000 00FA        {
; 0000 00FB 
; 0000 00FC        PORTD.2=1;
	SBI  0x12,2
; 0000 00FD        OCR1A=ml2+255;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x9E:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00FE        }
; 0000 00FF 
; 0000 0100        //MR2
; 0000 0101        if(mr2>0)
_0x2B:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRGE _0x2E
; 0000 0102        {
; 0000 0103        PORTD.1=0;
	CBI  0x12,1
; 0000 0104        OCR1B=mr2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x9F
; 0000 0105        }
; 0000 0106        else if(mr2<=0)
_0x2E:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRLT _0x32
; 0000 0107        {
; 0000 0108        PORTD.1=1;
	SBI  0x12,1
; 0000 0109        OCR1B=mr2+255;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x9F:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 010A        }
; 0000 010B        //MR1
; 0000 010C        if(mr1>0)
_0x32:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRGE _0x35
; 0000 010D        {
; 0000 010E        PORTD.0=0;
	CBI  0x12,0
; 0000 010F        OCR0=mr1;
	LD   R30,Y
	RJMP _0xA0
; 0000 0110        }
; 0000 0111        else if(mr1<=0)
_0x35:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRLT _0x39
; 0000 0112        {
; 0000 0113        PORTD.0=1;
	SBI  0x12,0
; 0000 0114        OCR0=mr1+255;
	LD   R30,Y
	SUBI R30,-LOW(255)
_0xA0:
	OUT  0x3C,R30
; 0000 0115        }
; 0000 0116 }
_0x39:
	ADIW R28,8
	RET
; .FEND
;void move(int direction)
; 0000 0118 {
_move:
; .FSTART _move
; 0000 0119    if(direction==0)       motor(255,255,-255,-255);
	ST   -Y,R27
	ST   -Y,R26
;	direction -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x3C
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	RJMP _0xA1
; 0000 011A 
; 0000 011B        else if(direction==1)  motor(255,128,-255,-128);
_0x3C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x3E
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	LDI  R26,LOW(65408)
	LDI  R27,HIGH(65408)
	RJMP _0xA2
; 0000 011C 
; 0000 011D        else if(direction==2)  motor(255,0,-255,0);
_0x3E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x40
	CALL SUBOPT_0x13
	CALL SUBOPT_0x15
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _0xA2
; 0000 011E 
; 0000 011F        else if(direction==3)  motor(255,-128,-255,128);
_0x40:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x42
	CALL SUBOPT_0x13
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	LDI  R26,LOW(128)
	LDI  R27,0
	RJMP _0xA2
; 0000 0120 
; 0000 0121        else if(direction==4)  motor(255,-255,-255,255);
_0x42:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0x44
	CALL SUBOPT_0x13
	CALL SUBOPT_0x17
	CALL SUBOPT_0x17
	LDI  R26,LOW(255)
	LDI  R27,0
	RJMP _0xA2
; 0000 0122 
; 0000 0123        else if(direction==5)  motor(128,-255,-128,255);
_0x44:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRNE _0x46
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	LDI  R26,LOW(255)
	LDI  R27,0
	RJMP _0xA2
; 0000 0124 
; 0000 0125        else if(direction==6)  motor(0,-255,0,255);
_0x46:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0x48
	CALL SUBOPT_0x15
	CALL SUBOPT_0x18
	LDI  R26,LOW(255)
	LDI  R27,0
	RJMP _0xA2
; 0000 0126 
; 0000 0127        else if(direction==7)  motor(-128,-255,128,255);
_0x48:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x4A
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0x19
	LDI  R26,LOW(255)
	LDI  R27,0
	RJMP _0xA2
; 0000 0128 
; 0000 0129        else if(direction==8)  motor(-255,-255,255,255);
_0x4A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x4C
	CALL SUBOPT_0x17
	CALL SUBOPT_0x17
	CALL SUBOPT_0x13
	LDI  R26,LOW(255)
	LDI  R27,0
	RJMP _0xA2
; 0000 012A 
; 0000 012B        else if(direction==9)  motor(-255,-128,255,128);
_0x4C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRNE _0x4E
	CALL SUBOPT_0x17
	CALL SUBOPT_0x16
	CALL SUBOPT_0x13
	LDI  R26,LOW(128)
	LDI  R27,0
	RJMP _0xA2
; 0000 012C 
; 0000 012D        else if(direction==10) motor(-255,0,255,0);
_0x4E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRNE _0x50
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	CALL SUBOPT_0x13
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _0xA2
; 0000 012E 
; 0000 012F        else if(direction==11) motor(-255,128,255,-128);
_0x50:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,11
	BRNE _0x52
	CALL SUBOPT_0x17
	CALL SUBOPT_0x19
	CALL SUBOPT_0x13
	LDI  R26,LOW(65408)
	LDI  R27,HIGH(65408)
	RJMP _0xA2
; 0000 0130 
; 0000 0131        else if(direction==12) motor(-255,255,255,-255);
_0x52:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,12
	BRNE _0x54
	CALL SUBOPT_0x17
	CALL SUBOPT_0x13
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0xA1
; 0000 0132 
; 0000 0133        else if(direction==13)  motor(-128,255,128,-255);
_0x54:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,13
	BRNE _0x56
	CALL SUBOPT_0x16
	CALL SUBOPT_0x13
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RJMP _0xA1
; 0000 0134 
; 0000 0135        else if(direction==14)  motor(0,255,0,-255);
_0x56:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,14
	BRNE _0x58
	CALL SUBOPT_0x18
	CALL SUBOPT_0x13
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0xA1
; 0000 0136 
; 0000 0137        else if(direction==15)  motor(128,255,-128,-255);
_0x58:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,15
	BRNE _0x5A
	CALL SUBOPT_0x19
	CALL SUBOPT_0x13
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
_0xA1:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(65281)
	LDI  R27,HIGH(65281)
_0xA2:
	RCALL _motor
; 0000 0138 
; 0000 0139 
; 0000 013A 
; 0000 013B }
_0x5A:
	JMP  _0x2020002
; .FEND
;
;
;
; void  shift()
; 0000 0140  {
; 0000 0141 
; 0000 0142  }
;
;
;void main(void)
; 0000 0146 {
_main:
; .FSTART _main
; 0000 0147 // Declare your local variables here
; 0000 0148 
; 0000 0149 // Input/Output Ports initialization
; 0000 014A // Port A initialization
; 0000 014B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 014C DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 014D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 014E PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 014F 
; 0000 0150 // Port B initialization
; 0000 0151 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 0152 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(252)
	OUT  0x17,R30
; 0000 0153 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 0154 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0155 
; 0000 0156 // Port C initialization
; 0000 0157 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0158 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0159 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 015A PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 015B 
; 0000 015C // Port D initialization
; 0000 015D // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 015E DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 015F // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0160 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0161 
; 0000 0162 // Timer/Counter 0 initialization
; 0000 0163 // Clock source: System Clock
; 0000 0164 // Clock value: 125/000 kHz
; 0000 0165 // Mode: Fast PWM top=0xFF
; 0000 0166 // OC0 output: Non-Inverted PWM
; 0000 0167 // Timer Period: 2/048 ms
; 0000 0168 // Output Pulse(s):
; 0000 0169 // OC0 Period: 2/048 ms Width: 0 us
; 0000 016A TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 016B TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 016C OCR0=0x00;
	OUT  0x3C,R30
; 0000 016D 
; 0000 016E // Timer/Counter 1 initialization
; 0000 016F // Clock source: System Clock
; 0000 0170 // Clock value: 125/000 kHz
; 0000 0171 // Mode: Fast PWM top=0x00FF
; 0000 0172 // OC1A output: Non-Inverted PWM
; 0000 0173 // OC1B output: Non-Inverted PWM
; 0000 0174 // Noise Canceler: Off
; 0000 0175 // Input Capture on Falling Edge
; 0000 0176 // Timer Period: 2/048 ms
; 0000 0177 // Output Pulse(s):
; 0000 0178 // OC1A Period: 2/048 ms Width: 0 us
; 0000 0179 // OC1B Period: 2/048 ms Width: 0 us
; 0000 017A // Timer1 Overflow Interrupt: Off
; 0000 017B // Input Capture Interrupt: Off
; 0000 017C // Compare A Match Interrupt: Off
; 0000 017D // Compare B Match Interrupt: Off
; 0000 017E TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 017F TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 0180 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0181 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0182 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0183 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0184 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0185 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0186 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0187 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0188 
; 0000 0189 // Timer/Counter 2 initialization
; 0000 018A // Clock source: System Clock
; 0000 018B // Clock value: 125/000 kHz
; 0000 018C // Mode: Fast PWM top=0xFF
; 0000 018D // OC2 output: Non-Inverted PWM
; 0000 018E // Timer Period: 2/048 ms
; 0000 018F // Output Pulse(s):
; 0000 0190 // OC2 Period: 2/048 ms Width: 0 us
; 0000 0191 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0192 TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 0193 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0194 OCR2=0x00;
	OUT  0x23,R30
; 0000 0195 
; 0000 0196 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0197 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0198 
; 0000 0199 // External Interrupt(s) initialization
; 0000 019A // INT0: Off
; 0000 019B // INT1: Off
; 0000 019C // INT2: Off
; 0000 019D MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 019E MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 019F 
; 0000 01A0 // USART initialization
; 0000 01A1 // USART disabled
; 0000 01A2 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 01A3 
; 0000 01A4 // Analog Comparator initialization
; 0000 01A5 // Analog Comparator: Off
; 0000 01A6 // The Analog Comparator's positive input is
; 0000 01A7 // connected to the AIN0 pin
; 0000 01A8 // The Analog Comparator's negative input is
; 0000 01A9 // connected to the AIN1 pin
; 0000 01AA ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01AB 
; 0000 01AC // ADC initialization
; 0000 01AD // ADC Clock frequency: 62/500 kHz
; 0000 01AE // ADC Voltage Reference: AVCC pin
; 0000 01AF // ADC Auto Trigger Source: ADC Stopped
; 0000 01B0 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 01B1 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 01B2 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01B3 
; 0000 01B4 // SPI initialization
; 0000 01B5 // SPI disabled
; 0000 01B6 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 01B7 
; 0000 01B8 // TWI initialization
; 0000 01B9 // TWI disabled
; 0000 01BA TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 01BB 
; 0000 01BC // Bit-Banged I2C Bus initialization
; 0000 01BD // I2C Port: PORTB
; 0000 01BE // I2C SDA bit: 1
; 0000 01BF // I2C SCL bit: 0
; 0000 01C0 // Bit Rate: 100 kHz
; 0000 01C1 // Note: I2C settings are specified in the
; 0000 01C2 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 01C3 i2c_init();
	CALL _i2c_init
; 0000 01C4 
; 0000 01C5 // Alphanumeric LCD initialization
; 0000 01C6 // Connections are specified in the
; 0000 01C7 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 01C8 // RS - PORTC Bit 0
; 0000 01C9 // RD - PORTC Bit 1
; 0000 01CA // EN - PORTC Bit 2
; 0000 01CB // D4 - PORTC Bit 4
; 0000 01CC // D5 - PORTC Bit 5
; 0000 01CD // D6 - PORTC Bit 6
; 0000 01CE // D7 - PORTC Bit 7
; 0000 01CF // Characters/line: 16
; 0000 01D0 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 01D1 
; 0000 01D2 delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 01D3 
; 0000 01D4 
; 0000 01D5 while (1)
_0x5B:
; 0000 01D6       {
; 0000 01D7        if(PINC.3==1)
	SBIS 0x13,3
	RJMP _0x5E
; 0000 01D8        {
; 0000 01D9 
; 0000 01DA 
; 0000 01DB 
; 0000 01DC     c=compass_read(1);
	LDI  R26,LOW(1)
	RCALL _compass_read
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 01DD     sf=read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	LDI  R26,LOW(_sf)
	LDI  R27,HIGH(_sf)
	CALL __EEPROMWRW
; 0000 01DE     sr=read_adc(4);
	LDI  R26,LOW(4)
	RCALL _read_adc
	LDI  R26,LOW(_sr)
	LDI  R27,HIGH(_sr)
	CALL __EEPROMWRW
; 0000 01DF     sl=read_adc(6);
	LDI  R26,LOW(6)
	RCALL _read_adc
	LDI  R26,LOW(_sl)
	LDI  R27,HIGH(_sl)
	CALL __EEPROMWRW
; 0000 01E0     sb=read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	LDI  R26,LOW(_sb)
	LDI  R27,HIGH(_sb)
	CALL __EEPROMWRW
; 0000 01E1 
; 0000 01E2 
; 0000 01E3 
; 0000 01E4 
; 0000 01E5            }
; 0000 01E6 
; 0000 01E7 
; 0000 01E8        read_cmp();
_0x5E:
	RCALL _read_cmp
; 0000 01E9        read_sensor();
	RCALL _read_sensor
; 0000 01EA        if(cmp<=20 && cmp>=-20) cmp*=-4;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R4
	CPC  R31,R5
	BRLT _0x60
	LDI  R30,LOW(65516)
	LDI  R31,HIGH(65516)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x61
_0x60:
	RJMP _0x5F
_0x61:
	MOVW R30,R4
	LDI  R26,LOW(65532)
	LDI  R27,HIGH(65532)
	CALL __MULW12
	RJMP _0xA3
; 0000 01EB        else cmp=-cmp;
_0x5F:
	MOVW R30,R4
	CALL __ANEGW1
_0xA3:
	MOVW R4,R30
; 0000 01EC 
; 0000 01ED        if(adc[adc_min]<800)
	MOVW R30,R8
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	CPI  R30,LOW(0x320)
	LDI  R26,HIGH(0x320)
	CPC  R31,R26
	BRLT PC+2
	RJMP _0x63
; 0000 01EE          {
; 0000 01EF          if(kr>50)
	RCALL SUBOPT_0xF
	SBIW R26,51
	BRLT _0x64
; 0000 01F0          {
; 0000 01F1           while (adc_min<=8 && adc_min>=0)
_0x65:
	CALL SUBOPT_0x1A
	BRLT _0x68
	CLR  R0
	CP   R8,R0
	CPC  R9,R0
	BRGE _0x69
_0x68:
	RJMP _0x67
_0x69:
; 0000 01F2           {
; 0000 01F3            read_sensor();
	RCALL _read_sensor
; 0000 01F4            read_cmp();
	RCALL _read_cmp
; 0000 01F5             if(shr>400 ||  (kr>50 || kl>50))  motor(-170,170,170,-170);
	RCALL SUBOPT_0xE
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRGE _0x6B
	RCALL SUBOPT_0xF
	SBIW R26,51
	BRGE _0x6C
	RCALL SUBOPT_0x11
	SBIW R26,51
	BRLT _0x6D
_0x6C:
	RJMP _0x6B
_0x6D:
	RJMP _0x6A
_0x6B:
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
	LDI  R26,LOW(65366)
	LDI  R27,HIGH(65366)
	RJMP _0xA4
; 0000 01F6            else if(kf>50) move(10);
_0x6A:
	RCALL SUBOPT_0x12
	SBIW R26,51
	BRLT _0x70
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _move
; 0000 01F7            else if(kb>50) move(14);
	RJMP _0x71
_0x70:
	RCALL SUBOPT_0x10
	SBIW R26,51
	BRLT _0x72
	LDI  R26,LOW(14)
	LDI  R27,0
	RCALL _move
; 0000 01F8            else if(shr<250) break;
	RJMP _0x73
_0x72:
	RCALL SUBOPT_0xE
	CPI  R26,LOW(0xFA)
	LDI  R30,HIGH(0xFA)
	CPC  R27,R30
	BRLT _0x67
; 0000 01F9            else  motor(0,0,0,0);
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	LDI  R26,LOW(0)
	LDI  R27,0
_0xA4:
	RCALL _motor
; 0000 01FA           }
_0x73:
_0x71:
	RJMP _0x65
_0x67:
; 0000 01FB 
; 0000 01FC           }
; 0000 01FD          else if(kl>50)
	RJMP _0x76
_0x64:
	RCALL SUBOPT_0x11
	SBIW R26,51
	BRLT _0x77
; 0000 01FE          {
; 0000 01FF           while ((adc_min>=8 && adc_min>=15) || adc_min==0)
_0x78:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x7B
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x7D
_0x7B:
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BRNE _0x7A
_0x7D:
; 0000 0200           {
; 0000 0201            read_sensor();
	RCALL _read_sensor
; 0000 0202            read_cmp();
	RCALL _read_cmp
; 0000 0203             if(shl>400 ||  (kr>50 || kl>50))  motor(170,-170,-170,170);
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R30,R10
	CPC  R31,R11
	BRLT _0x80
	RCALL SUBOPT_0xF
	SBIW R26,51
	BRGE _0x81
	RCALL SUBOPT_0x11
	SBIW R26,51
	BRLT _0x82
_0x81:
	RJMP _0x80
_0x82:
	RJMP _0x7F
_0x80:
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1B
	LDI  R26,LOW(170)
	RJMP _0xA5
; 0000 0204            else if(kf>50) move(6);
_0x7F:
	RCALL SUBOPT_0x12
	SBIW R26,51
	BRLT _0x85
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _move
; 0000 0205            else if(kb>50) move(2);
	RJMP _0x86
_0x85:
	RCALL SUBOPT_0x10
	SBIW R26,51
	BRLT _0x87
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _move
; 0000 0206            else if(shl<250) break;
	RJMP _0x88
_0x87:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x7A
; 0000 0207            else  motor(0,0,0,0);
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	LDI  R26,LOW(0)
_0xA5:
	LDI  R27,0
	RCALL _motor
; 0000 0208           }
_0x88:
_0x86:
	RJMP _0x78
_0x7A:
; 0000 0209 
; 0000 020A           }
; 0000 020B 
; 0000 020C          if(adc_min==0)move(0);
_0x77:
_0x76:
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x8B
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _0xA6
; 0000 020D          else if(adc_min==1) move(1);
_0x8B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x8D
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP _0xA6
; 0000 020E          else if(adc_min==15) move(15);
_0x8D:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x8F
	LDI  R26,LOW(15)
	LDI  R27,0
	RJMP _0xA6
; 0000 020F          else if(adc_min==2) move(3);
_0x8F:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x91
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _0xA6
; 0000 0210          else if(adc_min==14) move(13);
_0x91:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x93
	LDI  R26,LOW(13)
	LDI  R27,0
	RJMP _0xA6
; 0000 0211          else if(adc_min<=8)move(adc_min+2);
_0x93:
	RCALL SUBOPT_0x1A
	BRLT _0x95
	MOVW R26,R8
	ADIW R26,2
	RJMP _0xA6
; 0000 0212          else if(adc_min>8) move(adc_min-2);
_0x95:
	RCALL SUBOPT_0x1A
	BRGE _0x97
	MOVW R26,R8
	SBIW R26,2
_0xA6:
	RCALL _move
; 0000 0213        }
_0x97:
; 0000 0214        else
	RJMP _0x98
_0x63:
; 0000 0215       {
; 0000 0216 
; 0000 0217            if(shb<200)
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x99
; 0000 0218                         motor(-170-e,-170+e,170+e,170-e);
	LDS  R26,_e
	LDS  R27,_e+1
	LDI  R30,LOW(65366)
	LDI  R31,HIGH(65366)
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x1D
	SUBI R30,LOW(-65366)
	SBCI R31,HIGH(-65366)
	RCALL SUBOPT_0x1D
	SUBI R30,LOW(-170)
	SBCI R31,HIGH(-170)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_e
	LDS  R27,_e+1
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	RJMP _0xA7
; 0000 0219             else motor(0,0,0,0);
_0x99:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	LDI  R26,LOW(0)
	LDI  R27,0
_0xA7:
	RCALL _motor
; 0000 021A       }
_0x98:
; 0000 021B 
; 0000 021C       e=shl-shr;
	RCALL SUBOPT_0xE
	MOVW R30,R10
	SUB  R30,R26
	SBC  R31,R27
	STS  _e,R30
	STS  _e+1,R31
; 0000 021D 
; 0000 021E 
; 0000 021F 
; 0000 0220 
; 0000 0221 
; 0000 0222 
; 0000 0223 
; 0000 0224 
; 0000 0225 
; 0000 0226 
; 0000 0227 
; 0000 0228    }
	RJMP _0x5B
; 0000 0229 
; 0000 022A 
; 0000 022B }
_0x9B:
	RJMP _0x9B
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x2020001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2020001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2020002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x1E
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x1E
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020001
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2020001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	RCALL SUBOPT_0x0
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_adc:
	.BYTE 0x20
_shr:
	.BYTE 0x2
_e:
	.BYTE 0x2
_kr:
	.BYTE 0x2
_kf:
	.BYTE 0x2
_kl:
	.BYTE 0x2
_kb:
	.BYTE 0x2

	.ESEG
_c:
	.BYTE 0x2
_sr:
	.BYTE 0x2
_sb:
	.BYTE 0x2
_sl:
	.BYTE 0x2
_sf:
	.BYTE 0x2

	.DSEG
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x0:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL _i2c_write
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	CALL __EEPROMRDW
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:96 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:107 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	MOVW R30,R4
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __DIVW21
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDS  R26,_shr
	LDS  R27,_shr+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDS  R26,_kr
	LDS  R27,_kr+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDS  R26,_kb
	LDS  R27,_kb+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDS  R26,_kl
	LDS  R27,_kl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDS  R26,_kf
	LDS  R27,_kf+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(65366)
	LDI  R31,HIGH(65366)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_e
	LDS  R31,_e+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	RJMP SUBOPT_0x0


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x18 ;PORTB
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
