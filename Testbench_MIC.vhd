LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

----------- Entidade do Testbench -------
ENTITY Testbench IS

END Testbench;

----------- Arquitetura do Testbench -------
ARCHITECTURE Type_3 OF Testbench IS

    CONSTANT ADDRESS : INTEGER := 5;
    CONSTANT DATE : INTEGER := 10;
    CONSTANT Clk_period : TIME := 40 ns;
    SIGNAL Clk_count : INTEGER := 0;

    -- Declara��o de sinais (entrada e sa�da) que conectar�o o projeto ao teste
    SIGNAL Signal_Reset : STD_LOGIC := '0';
    SIGNAL Signal_Clk : STD_LOGIC := '0';
    SIGNAL Signal_Enc : STD_LOGIC := '0';
    SIGNAL Signal_Amux : STD_LOGIC := '0';
    SIGNAL Signal_Mbr : STD_LOGIC := '0';
    SIGNAL Signal_Mar : STD_LOGIC := '0';
    SIGNAL Signal_Rd : STD_LOGIC := '0';
    SIGNAL Signal_Wr : STD_LOGIC := '0';
    SIGNAL Signal_Data_Ok : STD_LOGIC := '0';
    SIGNAL Signal_Sh : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL Signal_Alu : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

    SIGNAL Signal_A_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Signal_B_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Signal_C_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Signal_Mem_To_Mbr : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";

    SIGNAL Signal_Mbr_To_Mem : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    SIGNAL Signal_Mar_Output : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
    SIGNAL Signal_Rd_Output : STD_LOGIC := '0';
    SIGNAL Signal_Wr_Output : STD_LOGIC := '0';
    SIGNAL Signal_Z : STD_LOGIC := '0';
    SIGNAL Signal_N : STD_LOGIC := '0';

    -- Declara��o de sinais que definir�o a sa�da esperada quando o projeto for simulado
    SIGNAL Expected_Mbr_To_Mem : STD_LOGIC_VECTOR(15 DOWNTO 0);
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

    FUNCTION Clk_To_Ns(n : INTEGER := 1) RETURN TIME IS VARIABLE Total_Ns : TIME;
    BEGIN
        Total_Ns := n * Clk_period;
        RETURN Total_Ns;
    END FUNCTION;

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
        MEM_TO_MBR => Signal_Mem_To_Mbr,
        DATA_OK => Signal_Data_Ok,
        MBR_TO_MEM => Signal_Mbr_To_Mem,
        MAR_OUTPUT => Signal_Mar_Output,
        RD_OUTPUT => Signal_Rd_Output,
        WR_OUTPUT => Signal_Wr_Output,
        Z => Signal_Z,
        N => Signal_N);

    Clock_Process : PROCESS
    BEGIN
        Signal_Clk <= '0';
        WAIT FOR Clk_period/2; --for 0.5 ns signal is '0'.
        Signal_Clk <= '1';
        Clk_count <= Clk_count + 1;
        WAIT FOR Clk_period/2; --for next 0.5 ns signal is '1'.
        IF (Clk_count = 100) THEN
            REPORT "Stopping simulation after 100 cycles";
            WAIT;
        END IF;

    END PROCESS Clock_Process;

    Reset_Process : PROCESS
    BEGIN

    END PROCESS Reset_Process;

    Enc_Process : PROCESS
    BEGIN

    END PROCESS Enc_Process;

    Input_Process : PROCESS
    BEGIN

    END PROCESS Input_Process;

    Output_Process : PROCESS
    BEGIN

    END PROCESS Output_Process;
END Type_3;