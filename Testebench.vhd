library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

----------- Entidade do Testbench -------
ENTITY Testebench IS

END Testebench;

----------- Arquitetura do Testbench -------
Architecture Type_3 OF Testebench IS

CONSTANT ADDRESS : integer := 5;
CONSTANT DATE : integer := 10;
CONSTANT Clk_period : time := 40 ns;
SIGNAL Clk_count : integer := 0;

-- Declara��o de sinais (entrada e sa�da) que conectar�o o projeto ao teste
SIGNAL 	Signal_Reset		: std_logic := '0';
SIGNAL	Signal_Clk		: std_logic := '0';
SIGNAL	Signal_Enc		: std_logic := '0';
SIGNAL	Signal_Amux		: std_logic := '0';
SIGNAL	Signal_Mbr		: std_logic := '0';
SIGNAL	Signal_Mar		: std_logic := '0';
SIGNAL	Signal_Rd		: std_logic := '0';
SIGNAL 	Signal_Wr		: std_logic := '0';
SIGNAL	Signal_Data_Ok	: std_logic := '0';
SIGNAL	Signal_Sh		: std_logic_vector(1 DOWNTO 0) := "00";
SIGNAL	Signal_Alu		: std_logic_vector(1 DOWNTO 0) := "00";

SIGNAL	Signal_A_Address	: std_logic_vector(3 DOWNTO 0) := "0000";
SIGNAL	Signal_B_Address	: std_logic_vector(3 DOWNTO 0) := "0000";
SIGNAL	Signal_C_Address	: std_logic_vector(3 DOWNTO 0) := "0000";
SIGNAL	Signal_Mem_To_Mbr	: std_logic_vector(15 DOWNTO 0) := "0000000000000000";

SIGNAL	Signal_Mbr_To_Mem	: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
SIGNAL	Signal_Mar_Output	: std_logic_vector(11 DOWNTO 0) := "000000000000";
SIGNAL 	Signal_Rd_Output		: std_logic := '0';
SIGNAL 	Signal_Wr_Output		: std_logic := '0';
SIGNAL 	Signal_Z		: std_logic := '0';
SIGNAL 	Signal_N		: std_logic := '0';


-- Declara��o de sinais que definir�o a sa�da esperada quando o projeto for simulado
--SIGNAL Expected_Mbr_To_Mem	: std_logic_vector(15 DOWNTO 0);
--SIGNAL Expected_Mar_Output	: std_logic_vector(11 DOWNTO 0);
--SIGNAL Expected_Rd_Output	: std_logic;
--SIGNAL Expected_Wr_Output	: std_logic;
--SIGNAL Expected_Z	: std_logic;
--SIGNAL Expected_N	: std_logic;


-- Instancia��o do projeto a ser testado
COMPONENT PROJETO_MIC IS

PORT (CLK : IN STD_LOGIC;
	RESET : IN STD_LOGIC;
	AMUX : IN STD_LOGIC;
	ALU : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	MBR : IN STD_LOGIC;
	MAR : IN STD_LOGIC;
	RD : IN STD_LOGIC;
	WR : IN STD_LOGIC;
	ENC : IN STD_LOGIC;
	C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	SH : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	MEM_TO_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	DATA_OK : IN STD_LOGIC;
	MBR_TO_MEM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	MAR_OUTPUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	RD_OUTPUT : OUT STD_LOGIC;
	WR_OUTPUT : OUT STD_LOGIC;
	Z : OUT STD_LOGIC;
	N : OUT STD_LOGIC);
END COMPONENT;

BEGIN

-- Instancia��o do projeto a ser testado
Dut: PROJETO_MIC

PORT MAP (
	CLK => Signal_Clk,
	RESET => Signal_Reset,
	AMUX => Signal_Amux,
	ALU => Signal_Alu,
	MBR => Signal_Mbr,
	MAR => Signal_Mar,
	RD => Signal_Rd,
	WR => Signal_Wr,
	ENC => Signal_Enc,
	C => Signal_C_Address,
	B => Signal_B_Address,
	A => Signal_A_Address,
	SH => Signal_Sh,
	MEM_TO_MBR => Signal_Mem_To_Mbr,
	DATA_OK => Signal_Data_Ok,
	MBR_TO_MEM => Signal_Mbr_To_Mem,
	MAR_OUTPUT => Signal_Mar_Output,
	RD_OUTPUT => Signal_Rd_Output,
	WR_OUTPUT => Signal_Wr_Output,
	Z => Signal_Z,
	N => Signal_N)
;

-- Processo que define o rel�gio. Faremos um rel�gio de 40 ns
Clock_Process : PROCESS 
  Begin
    Signal_Clk <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    Signal_Clk  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.


IF (Clk_count = 2) THEN     
REPORT "Stopping simulkation after 34 cycles";
    	  Wait;       
END IF;

End Process Clock_Process;

-- Processo que define o Reset. Subiremos o sinal de Reset em 10 ns. Manteremos este sinal com valor alto por mais trinta nanos segundo e voltaremos o Reset para zero
Reset_Process : PROCESS 
  Begin
    Signal_Reset <= '0';
    Wait for 10 ns;
    Signal_Reset <= '1';
    Wait for 30 ns;
    Signal_Reset <= '0';
    wait;

End Process Reset_Process;

Enc_Process : PROCESS 
  Begin
   Signal_Enc <= '0';
    Wait for 40 ns;
    Signal_Enc <= '1';
    wait;
End Process Enc_Process;


Input_Process : PROCESS 
  Begin
-- Especifica��o inicial de valores ---
       
       
       wait for 40 ns; 
		 Signal_Data_Ok <= '1';
		 Signal_Mem_To_Mbr <= "0000000000000001";
		 Signal_Amux <= '1';
		 Signal_Alu <= "10";
		 Signal_Sh <= "00";
		 Signal_C_Address <= "1010";
		 --Signal_Mem_To_Mbr <= "0000000000000011";
		 
		 wait for 40 ns;
		 Signal_Data_Ok <= '1';
		 Signal_Mem_To_Mbr <= "0000000000000010";
		 Signal_Amux <= '1';
		 Signal_Alu <= "10";
		 Signal_Sh <= "00";
		 Signal_C_Address <= "1011";
		 
		 
		 wait for 40 ns;
       Signal_A_Address <= "1010"; 
		 Signal_B_Address <= "1011"; 
       Signal_Amux <= '0';
		 Signal_Alu <= "00";
		 Signal_Sh <= "00";
		 Signal_Mbr <= '1';
		 REPORT "A: "  & integer'image(to_integer(unsigned(Signal_Mbr_To_Mem)));
		
		 wait;
End Process Input_Process;

End Type_3;