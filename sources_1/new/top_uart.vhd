----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.01.2017 11:46:36
-- Design Name: 
-- Module Name: top_uart - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_uart is
    Generic (
		constant DATA_WIDTH  : positive := 8
	);
    Port ( 
           test : in std_logic;--------test button
           clk_in1_p, clk_in1_n : in std_logic; 
           DataInput	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
           WriteEn    : in  STD_LOGIC;
           ReadEn    : in  STD_LOGIC;
           Reset  : in  STD_LOGIC;
           Full	: out STD_LOGIC;
           tx: out std_logic           
        );
end top_uart;

architecture Behavioral of top_uart is

signal clock_sig : std_logic;
signal baud_sig : std_logic;
signal empty_sig : std_logic;
signal not_empty_sig : std_logic;
signal readEn_sig : std_logic;
signal DataOut_sig : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal DataIn_sig : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal tx_sig : std_logic;
-----test
--signal DANE : std_logic_vector(DATA_WIDTH - 1 downto 0):= "0011101";
signal test_sig : std_logic_vector(DATA_WIDTH - 1 downto 0);

    component clk_wiz_0
        port
         (-- Clock in ports
          clk_in1_p         : in     std_logic;
          clk_in1_n         : in     std_logic;
          -- Clock out ports
          clk_out1          : out    std_logic;
          -- Status and control signals
          reset             : in     std_logic
         );
    end component;
    
    component fifo
        Port ( 
            CLK        : in  STD_LOGIC;
            RST        : in  STD_LOGIC;
            WriteEn    : in  STD_LOGIC;
            DataIn    : in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            ReadEn    : in  STD_LOGIC;
            DataOut    : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            Empty    : out STD_LOGIC;
            Full    : out STD_LOGIC
        );
    end component;
    
    component tx_uart
        port (
            clk, reset: in std_logic;
            tx_start : in std_logic;
            s_tick: in std_logic;
            din: in std_logic_vector (7 downto 0);
            tx_done_tick: out std_logic;
            tx: out std_logic
            );
    end component;
    
    component clk307khz
        Port (
            clk_in : in  STD_LOGIC;
            reset  : in  STD_LOGIC;
            clk_out: out STD_LOGIC
        );
    end component;
    
begin

------------ test ------------------------
DataIn_sig <= DataInput;
--DataIn_sig <= "00000000";

------------ test -----------------------  
    not_empty_sig <= not empty_sig;

    Baud_gen : clk307kHz port map(
        clk_in => clock_sig,
        reset => Reset,
        clk_out => baud_sig
       );
               
    Transmiter : tx_uart port map(
        clk => clock_sig,
        reset => Reset,
        tx_start => not_empty_sig,
        s_tick => baud_sig,
        din => DataOut_sig,
        tx_done_tick => readEn_sig,
        tx => tx_sig
       );
       
     FIFO_buf : fifo port map(
        CLK => clock_sig,
        RST => Reset,
        WriteEn => WriteEn,
       ReadEn => ReadEn,-- ReadEn => readEn_sig,
        DataIn => DataIn_sig,
        DataOut => DataOut_sig,
        Empty => empty_sig,
        Full => Full
       );
       
     CLOCK : clk_wiz_0 port map(
        clk_in1_p => clk_in1_p,
        clk_in1_n => clk_in1_n,
        reset => Reset,
        clk_out1 => clock_sig
       );     
        
     tx <= tx_sig;
     
     
     
end Behavioral;
