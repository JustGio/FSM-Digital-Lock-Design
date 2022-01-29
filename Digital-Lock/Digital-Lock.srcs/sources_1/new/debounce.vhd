library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
  Port (clk: in std_logic;
        button_in: in std_logic;
        button_out: out std_logic );
end debounce;

architecture Behavioral of debounce is

signal FF1, FF2, FF3: std_logic;
signal counter:integer:=0;
constant stable_time: integer:=1250000; -- FPGA Clock: 125 Mhz -> 8 ns. Button press 10ms/8ns = 1250000
--constant stable_time:integer:=1;
signal enable: std_logic:='0';
signal result: std_logic:='0';

begin


process(clk)
begin

if (rising_edge(clk)) then
    FF1<=button_in;
    FF2<=FF1;
    if ((FF1 xor FF2) = '1' and enable='0') then
        counter<=0;
    elsif (counter >= stable_time) then
        enable<='1';
    else
        counter<=counter+1;
        
    end if;
    
        if (enable='1') then
            FF3<=FF2;
            enable<='0';
            counter<=0;
        else
            FF3<='0';

        end if;
    
    end if;

button_out<=FF3;
end process;

end Behavioral;
