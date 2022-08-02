LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE std.textio.ALL;

ENTITY Testbench_MIC IS

END Testbench_MIC;

ARCHITECTURE Type_3 OF Testbench_MIC IS

	CONSTANT Clk_period : TIME := 40 ns;
	SIGNAL Clk_count : INTEGER := 0;

	SIGNAL Signal_Clk : STD_LOGIC := '0';
	SIGNAL Signal_Reset : STD_LOGIC := '0';
	SIGNAL Signal_Amux : STD_LOGIC := '0';
	SIGNAL Signal_Alu : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL Signal_Mbr : STD_LOGIC := '0';
	SIGNAL Signal_Mar : STD_LOGIC := '0';
	SIGNAL Signal_Enc : STD_LOGIC := '0';
	SIGNAL Signal_C_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL Signal_B_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL Signal_A_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL Signal_Sh : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL Signal_Mem_to_mbr : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL Signal_Data_ok : STD_LOGIC := '0';
	SIGNAL Signal_Mbr_to_mem : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL Signal_Mar_to_mem : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
	SIGNAL Signal_z : STD_LOGIC := '0';
	SIGNAL Signal_n : STD_LOGIC := '0';
	SIGNAL Signal_Rd : STD_LOGIC := '0';
	SIGNAL Signal_Wr : STD_LOGIC := '0';
	SIGNAL Signal_Rd_OUTPUT : STD_LOGIC := '0';
	SIGNAL Signal_Wr_OUTPUT : STD_LOGIC := '0';
	SIGNAL Expected_Mbr_To_Mem : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL Expected_Mar_Output : STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL Expected_Rd_Output : STD_LOGIC;
	SIGNAL Expected_Wr_Output : STD_LOGIC;
	SIGNAL Expected_Z : STD_LOGIC;
	SIGNAL Expected_N : STD_LOGIC;

	COMPONENT PROJETO_MIC IS
		PORT (
			CLK : IN STD_LOGIC;
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

	Dut : PROJETO_MIC

	PORT MAP(
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
		MEM_TO_MBR => Signal_Mem_to_mbr,
		DATA_OK => Signal_Data_ok,
		MBR_TO_MEM => Signal_Mbr_to_mem,
		MAR_OUTPUT => Signal_Mar_to_mem,
		RD_OUTPUT => Signal_Rd_output,
		WR_OUTPUT => Signal_Wr_output,
		Z => Signal_z,
		N => Signal_n
	);

	-- Processo que define o rel gio. Faremos um relogio de 40 ns
	Clock_Process : PROCESS
	BEGIN
		Signal_Clk <= '0';
		WAIT FOR Clk_period/2; --for 0.5 ns signal is '0'.
		Signal_Clk <= '1';
		Clk_count <= Clk_count + 1;
		WAIT FOR Clk_period/2; --for next 0.5 ns signal is '1'.

		IF (Clk_count = 11) THEN
			REPORT "Stopping simulation AFTER 11 cycles";
			WAIT;
		END IF;

	END PROCESS Clock_Process;

	-- Processo que define o Reset. Subiremos o sinal de Reset em 10 ns. Manteremos este sinal com valor alto por mais trinta nanos segundo e voltaremos o Reset para zero
	Reset_Process : PROCESS
	BEGIN
		Signal_Reset <= '0';
		WAIT FOR 10 ns;
		Signal_Reset <= '1';
		WAIT FOR 30 ns;
		Signal_Reset <= '0';
		WAIT;

	END PROCESS Reset_Process;

	PROCESS IS

		-- TRANSPARENCIA DO CONTEUDO DE MBR
		PROCEDURE MbrTransparency(Mbr_Value : IN STD_LOGIC_VECTOR(15 DOWNTO 0)) IS
		BEGIN
			Signal_Mem_to_mbr <= Mbr_Value;
			Signal_Enc <= '0';
			Signal_Sh <= "00";
			Signal_Mbr <= '0';

			WAIT FOR 40 ns;

			Signal_Amux <= '1';
			Signal_Alu <= "10";

		END PROCEDURE;

		-- TRANSPARENCIA DE UM REGISTRADOR
		PROCEDURE RegisterTransparency(Address : IN STD_LOGIC_VECTOR(3 DOWNTO 0)) IS
		BEGIN
			Signal_Enc <= '0';
			Signal_Mbr <= '0';
			Signal_Sh <= "00";
			Signal_Amux <= '0';
			Signal_Alu <= "10";
			Signal_A_Address <= Address;

		END PROCEDURE;

		-- ARMAZENA O CONTEUDO DO BARRAMENTO C EM UM REGISTRADOR
		PROCEDURE StoreInRegister(Address : IN STD_LOGIC_VECTOR(3 DOWNTO 0)) IS
		BEGIN
			Signal_C_Address <= Address;
			Signal_Enc <= '1';
			Signal_Mbr <= '0';

		END PROCEDURE;

		-- ARMAZENA O VALOR DO BARRAMENTO C EM MBR
		PROCEDURE StoreInMem IS
		BEGIN
			Signal_Mbr <= '1';
			Signal_Enc <= '0';

		END PROCEDURE;

		-- SOMA UM REGISTRADOR COM O CONTEUDO DE MBR
		PROCEDURE SumRegisterWithMbr(
			Mbr_Value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			R_Address : IN STD_LOGIC_VECTOR(3 DOWNTO 0)) IS
		BEGIN
			Signal_Mem_to_mbr <= Mbr_Value;
			Signal_Mbr <= '0';
			Signal_Enc <= '0';
			Signal_Sh <= "00";

			WAIT FOR 40 ns;
			Signal_B_Address <= R_Address;
			Signal_Alu <= "00";
			Signal_Amux <= '1';

		END PROCEDURE;

		-- SOMA DOIS REGISTRADORES
		PROCEDURE SumRegisters(
			A_Address : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			B_Address : IN STD_LOGIC_VECTOR(3 DOWNTO 0)) IS
		BEGIN
			Signal_Mbr <= '0';
			Signal_Enc <= '0';
			Signal_Sh <= "00";
			Signal_Alu <= "00";
			Signal_Amux <= '0';
			Signal_A_Address <= A_Address;
			Signal_B_Address <= B_Address;
		END PROCEDURE;

	BEGIN
		Signal_Data_ok <= '1';
		
		--- ADDD ---
		WAIT FOR 40 ns;
		MbrTransparency("0000000000000001");
		StoreInRegister("0001");
		-- AC = 1

		WAIT FOR 40 ns;
		SumRegisterWithMbr(Mbr_Value => "0000000000000011", R_Address => "0001");
		StoreInMem;
		-- MBR_OUTPUT = 4
		
		--- ADDD ---
		
		--- LODD ---
		WAIT FOR 40 ns;

		MbrTransparency("0000000000000111");
		StoreInRegister("0001");
		--AC = 7
		
		WAIT FOR 40 ns;
		RegisterTransparency("0001");
		StoreInMem;
		--MBR_OUTPUT = 7
		
		--- LODD ---

		--- INSP ---
		WAIT FOR 40 ns;
		MbrTransparency("0000000000001111");
		StoreInRegister("1010");

		-- A = 15

		WAIT FOR 40 ns;

		SumRegisters("0010", "1010");
		StoreInRegister("0010");

		-- SP = 15 (SP + A)

		WAIT FOR 40 ns;

		RegisterTransparency("0010");
		StoreInMem;

		-- MBR_OUTPUT = 15
		
		--- INSP ---

		WAIT;

	END PROCESS;

	PROCESS IS -- PROCESSO DOS VALORES ESPERADOS
	BEGIN
		WAIT FOR 20 ns;

		WAIT FOR 160 ns;
		Expected_Mbr_To_Mem <= "0000000000000100";

		WAIT FOR 120 ns;
		Expected_Mbr_To_Mem <= "0000000000000111";

		WAIT FOR 160 ns;
		Expected_Mbr_To_Mem <= "0000000000001111";

		WAIT;

	END PROCESS;

	PROCESS IS -- PROCESSO DO ASSERT, VERIFICA A CADA 20 NS
	BEGIN
		WAIT FOR 20 ns;

		ASSERT Expected_Mbr_To_Mem = Signal_Mbr_To_mem
		REPORT "O RESULTADO DIFERE: OBTIDO - " & INTEGER'image(to_integer(unsigned(Signal_Mbr_To_mem))) & " ESPERADO - " & INTEGER'image(to_integer(unsigned(Expected_Mbr_To_Mem)))
			SEVERITY failure;

		IF now = 460 ns THEN
			ASSERT false
			REPORT "SIMULACAO CONCLUIDA COM SUCESSO"
				SEVERITY failure;
		END IF;

	END PROCESS;
END Type_3;