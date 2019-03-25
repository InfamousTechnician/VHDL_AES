--Implementation based upon http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf

--MIT License
--
--Copyright (c) 2018 Balazs Valer Fekete
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY aes128keyTB IS
END aes128keyTB;

ARCHITECTURE behavior OF aes128keyTB IS 

	COMPONENT aes128key
	PORT(
		reset : IN  std_logic;
		clock : IN  std_logic;
		empty : OUT  std_logic;
		load : IN  std_logic;
		key : IN  std_logic_vector(127 downto 0);
		plain : IN  std_logic_vector(127 downto 0);
		ready : OUT  std_logic;
		cipher : OUT  std_logic_vector(127 downto 0)
		);
	END COMPONENT;

	--Inputs
	signal reset : std_logic := '0';
	signal clock : std_logic := '0';
	signal load : std_logic := '0';
	signal key : std_logic_vector(127 downto 0) := (others => '0');
	signal plain : std_logic_vector(127 downto 0) := (others => '0');

	--Outputs
	signal empty : std_logic;
	signal ready : std_logic;
	signal cipher : std_logic_vector(127 downto 0);

	-- Clock period definitions
	constant clock_period : time := 10 ns;
 
BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: aes128key PORT MAP (
		reset => reset,
		clock => clock,
		empty => empty,
		load => load,
		key => key,
		plain => plain,
		ready => ready,
		cipher => cipher
		);

	-- Clock process definitions
	clock_process :process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;
 

	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		reset		<= '1';
		wait for 100 ns;	
		reset		<= '0';
		--begin testing
		wait for clock_period*10;
		--test vectors from the standard from the standard
		--key		<= x"2b7e151628aed2a6abf7158809cf4f3c";
		--plain	<= x"3243f6a8885a308d313198a2e0370734";
		key		<= x"000102030405060708090a0b0c0d0e0f";
		plain		<= x"00112233445566778899aabbccddeeff";
		load		<= '1';
		wait for clock_period;
		key		<= (others => '0');
		load		<= '0';
		wait for clock_period*48;
		wait;
	end process;

END;
