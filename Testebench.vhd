library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

----------- Entidade do Testbench -------
ENTITY Testbench IS

END Testbench;

----------- Arquitetura do Testbench -------
Architecture Type_3 OF Testbench IS

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
SIGNAL Expected_Mbr_To_Mem	: std_logic_vector(15 DOWNTO 0);
SIGNAL Expected_Mar_Output	: std_logic_vector(11 DOWNTO 0);
SIGNAL Expected_Rd_Output	: std_logic;
SIGNAL Expected_Wr_Output	: std_logic;
SIGNAL Expected_Z	: std_logic;
SIGNAL Expected_N	: std_logic;
