library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce_tb is
--  Port ( );
end debounce_tb;

architecture Behavioral of debounce_tb is
component debounce is
Port (clk: in std_logic;
        button_in: in std_logic;
        button_out: out std_logic );

end component debounce;

signal clk_tb, button_in_tb, button_out_tb: std_logic;

begin
uut: debounce port map (clk=>clk_tb, button_in=>button_in_tb, button_out=>button_out_tb);

process
begin
clk_tb<='0';
wait for 4 ns;
clk_tb<='1';
wait for 4 ns;
end process;

process
begin
button_in_tb<='1';
wait for 1 ms;
button_in_tb<='0';
wait for 1 ms;
button_in_tb<='1';
wait for 11 ms;
button_in_tb<='0';
wait for 1 ms;
button_in_tb<='1';
wait for 2 ms;
button_in_tb<='0';
wait for 12 ms;
button_in_tb<='1';
wait for 12 ms;
button_in_tb<='0';
wait for 2 ms;
wait;
end process;
end Behavioral;
