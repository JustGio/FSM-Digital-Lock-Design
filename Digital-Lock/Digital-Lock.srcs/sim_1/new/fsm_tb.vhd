


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm_tb is
--  Port ( );
end fsm_tb;

architecture Behavioral of fsm_tb is

component fsm is
    Port ( clk: in std_logic;
         button_n: in std_logic;
         button_e: in std_logic;
         button_s: in std_logic;
         button_w: in std_logic;
         led0: out std_logic;
         led1: out std_logic;
         led2: out std_logic);
end component fsm;


signal clk_tb, button_n, button_e, button_s, button_w: std_logic:='0';
signal led0_tb, led1_tb, led2_tb: std_logic;

begin

uut: fsm port map (clk=>clk_tb, button_n=>button_n,button_e=>button_e, button_s=>button_s, button_w=>button_w, led0=>led0_tb, led1=>led1_tb, led2=>led2_tb);

process
begin
clk_tb<='0';
wait for 4 ns;
clk_tb<='1';
wait for 4 ns;

end process;


process
begin
button_s<='0';
wait for 12 ms;
button_w<='0';
wait for 12 ms;
button_e <= '0';
wait for 12 ms;
-- Testing for Unlock
button_s<='1';
wait for 11 ms;
button_s<='0';
wait for 20 ms;

button_w<='1';
wait for 12 ms;
button_w<='0';
wait for 20 ms;

button_e<='1';
wait for 11 ms;
button_e<='0';
wait for 20 ms;

button_w <= '1';
wait for 11 ms;
button_w <= '0';
wait for 20 ms;

-- Resetting to Lock
button_s<='1';
wait for 11 ms;
button_s<='0';
wait for 20 ms;
-- Back to Lock State
-- Testing: Wrong Combination -> Alarm State
button_n<='1';
wait for 11 ms;
button_n<='0';
wait for 20 ms;

button_s<='1';
wait for 11 ms;
button_s<='0';
wait for 20 ms;

button_w<='1';
wait for 11 ms;
button_w<='0';
wait for 20 ms;

button_w<='1';
wait for 11 ms;
button_w<='0';
wait for 20 ms;

-- At alarm state at this point in time. (to reset -> W then E must be pressed)
button_w<='1';
wait for 11 ms;
button_w<='0';
wait for 20 ms;

button_s<='1';
wait for 11 ms;
button_s<='0';
wait for 20 ms;

--- Back to alarm state (loop)
-- Testing to reset alarm.
button_w<='1';
wait for 11 ms;
button_w<='0';
wait for 20 ms;

button_e<='1';
wait for 11 ms;
button_e<='0';
wait for 20 ms;


-- Alarm is now reset. and back to Lock state.
-- Lighting LED0 then reset -> back to Lock state. Testing reset sequence.
button_e<='1';
wait for 11 ms;
button_e<='0';
wait for 20 ms;

button_e<='1';
wait for 11 ms;
button_e<='0';
wait for 20 ms;

wait;
end process;
end Behavioral;