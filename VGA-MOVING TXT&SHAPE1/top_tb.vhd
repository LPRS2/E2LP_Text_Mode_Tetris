--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:46:52 03/29/2015
-- Design Name:   
-- Module Name:   D:/LPRS-2/VGA-TEXT/top_tb.vhd
-- Project Name:  VGA-TEXT
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         FPGA_CLK : IN  std_logic;
         FPGA_RESET : IN  std_logic;
         iHcmd : IN  std_logic;
         iVcmd : IN  std_logic;
         VGA_HSYNC : OUT  std_logic;
         VGA_VSYNC : OUT  std_logic;
         BLANK : OUT  std_logic;
         PIX_CLOCK : OUT  std_logic;
         PSAVE : OUT  std_logic;
         SYNC : OUT  std_logic;
         RED0 : OUT  std_logic;
         RED1 : OUT  std_logic;
         RED2 : OUT  std_logic;
         RED3 : OUT  std_logic;
         RED4 : OUT  std_logic;
         RED5 : OUT  std_logic;
         RED6 : OUT  std_logic;
         RED7 : OUT  std_logic;
         GREEN0 : OUT  std_logic;
         GREEN1 : OUT  std_logic;
         GREEN2 : OUT  std_logic;
         GREEN3 : OUT  std_logic;
         GREEN4 : OUT  std_logic;
         GREEN5 : OUT  std_logic;
         GREEN6 : OUT  std_logic;
         GREEN7 : OUT  std_logic;
         BLUE0 : OUT  std_logic;
         BLUE1 : OUT  std_logic;
         BLUE2 : OUT  std_logic;
         BLUE3 : OUT  std_logic;
         BLUE4 : OUT  std_logic;
         BLUE5 : OUT  std_logic;
         BLUE6 : OUT  std_logic;
         BLUE7 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal FPGA_CLK : std_logic := '0';
   signal FPGA_RESET : std_logic := '0';
   signal iHcmd : std_logic := '0';
   signal iVcmd : std_logic := '0';

 	--Outputs
   signal VGA_HSYNC : std_logic;
   signal VGA_VSYNC : std_logic;
   signal BLANK : std_logic;
   signal PIX_CLOCK : std_logic;
   signal PSAVE : std_logic;
   signal SYNC : std_logic;
   signal RED0 : std_logic;
   signal RED1 : std_logic;
   signal RED2 : std_logic;
   signal RED3 : std_logic;
   signal RED4 : std_logic;
   signal RED5 : std_logic;
   signal RED6 : std_logic;
   signal RED7 : std_logic;
   signal GREEN0 : std_logic;
   signal GREEN1 : std_logic;
   signal GREEN2 : std_logic;
   signal GREEN3 : std_logic;
   signal GREEN4 : std_logic;
   signal GREEN5 : std_logic;
   signal GREEN6 : std_logic;
   signal GREEN7 : std_logic;
   signal BLUE0 : std_logic;
   signal BLUE1 : std_logic;
   signal BLUE2 : std_logic;
   signal BLUE3 : std_logic;
   signal BLUE4 : std_logic;
   signal BLUE5 : std_logic;
   signal BLUE6 : std_logic;
   signal BLUE7 : std_logic;

   -- Clock period definitions
   constant FPGA_CLK_period : time := 10 ns;
   constant PIX_CLOCK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          FPGA_CLK => FPGA_CLK,
          FPGA_RESET => FPGA_RESET,
          iHcmd => iHcmd,
          iVcmd => iVcmd,
          VGA_HSYNC => VGA_HSYNC,
          VGA_VSYNC => VGA_VSYNC,
          BLANK => BLANK,
          PIX_CLOCK => PIX_CLOCK,
          PSAVE => PSAVE,
          SYNC => SYNC,
          RED0 => RED0,
          RED1 => RED1,
          RED2 => RED2,
          RED3 => RED3,
          RED4 => RED4,
          RED5 => RED5,
          RED6 => RED6,
          RED7 => RED7,
          GREEN0 => GREEN0,
          GREEN1 => GREEN1,
          GREEN2 => GREEN2,
          GREEN3 => GREEN3,
          GREEN4 => GREEN4,
          GREEN5 => GREEN5,
          GREEN6 => GREEN6,
          GREEN7 => GREEN7,
          BLUE0 => BLUE0,
          BLUE1 => BLUE1,
          BLUE2 => BLUE2,
          BLUE3 => BLUE3,
          BLUE4 => BLUE4,
          BLUE5 => BLUE5,
          BLUE6 => BLUE6,
          BLUE7 => BLUE7
        );

   -- Clock process definitions
   FPGA_CLK_process :process
   begin
		FPGA_CLK <= '0';
		wait for FPGA_CLK_period/2;
		FPGA_CLK <= '1';
		wait for FPGA_CLK_period/2;
   end process;
 
   PIX_CLOCK_process :process
   begin
		PIX_CLOCK <= '0';
		wait for PIX_CLOCK_period/2;
		PIX_CLOCK <= '1';
		wait for PIX_CLOCK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      FPGA_RESET <= '0';
      wait for 100 ns;	
      FPGA_RESET <= '1';
		iHcmd <= '0';
      wait;

      -- insert stimulus here 

      wait;
   end process;

END;
