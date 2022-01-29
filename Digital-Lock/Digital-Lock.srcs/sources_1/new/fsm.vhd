library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
  Port ( clk: in std_logic;
         button_n: in std_logic;
         button_e: in std_logic;
         button_s: in std_logic;
         button_w: in std_logic;
         led0: out std_logic;
         led1: out std_logic;
         led2: out std_logic);
end fsm;

architecture Behavioral of fsm is

component debounce is
    Port (clk: in std_logic;
        button_in: in std_logic;
        button_out: out std_logic );
end component debounce;


type stateType is (LOCK, S1, S2, S3, Unlock, W1, W2, W3, Alarm, A1, R1, R2, R3, Reset);

-- buttons
signal button_n_out, button_e_out, button_s_out, button_w_out: std_logic;

signal current_state: stateType:=LOCK;
signal next_state: stateType;

signal flash_flag: std_logic:='0'; -- digital lock is unlocked when set to 1
signal alarm_flag: std_logic:='0'; -- alarm is active when alarm flag is set to 1
signal alarm_led: std_logic_vector(3 downto 0):="0101";
signal flash_led: std_logic_vector(3 downto 0):="0001";
begin

button0: debounce port map (clk=>clk, button_in=>button_n, button_out=>button_n_out);
button1: debounce port map (clk=>clk, button_in=>button_e, button_out=>button_e_out);
button2: debounce port map (clk=>clk, button_in=>button_s, button_out=>button_s_out);
button3: debounce port map (clk=>clk, button_in=>button_w, button_out=>button_w_out);

process (clk)
begin

    if (rising_edge(clk)) then
        current_state <= next_state;
    end if;
end process;


process (clk)
begin

    if (rising_edge(clk)) then
      case current_state is
        when LOCK =>
            if (button_s_out = '1') then
                next_state <= S1;
            elsif (button_e_out = '1') then
                next_state <= R1;
            elsif (button_n_out = '1' or button_w_out = '1') then
                next_state <= W1;
            end if;
        when S1 =>
             if (button_w_out = '1') then
                next_state <= S2;
             elsif (button_e_out = '1') then
                next_state <= R2;
             elsif (button_n_out = '1' or button_s_out = '1') then
                next_state <= W2;
             end if;   
        when S2 =>
            if (button_e_out = '1') then
                next_state <= S3;
            elsif (button_n_out = '1' or button_s_out = '1' or button_w_out = '1') then
                next_state <= W3;
           
             end if;
         when S3 =>
            if (button_w_out = '1') then
                next_state <= Unlock;
            elsif (button_e_out = '1') then
                next_state <= Reset;
            end if;
         when W1 =>
            if (button_e_out = '1') then
                next_state<= R2;
            elsif (button_n_out = '1' or button_s_out = '1' or button_w_out = '1') then
                next_state <= W2;
            end if;
        when W2 =>
            if (button_e_out = '1') then
                next_state <= R3;
            elsif (button_n_out = '1' or button_s_out = '1' or button_w_out = '1') then
                next_state <= W3;
            end if;
        when W3 =>
            if (button_n_out = '1' or button_e_out = '1' or button_s_out = '1' or button_w_out = '1') then
                   next_state <= Alarm;
             end if;
         when R1 =>
            if (button_e_out = '1') then
                next_state <= Reset;
            elsif (button_n_out = '1' or button_s_out = '1' or button_w_out = '1') then
                next_state <= W2;
                
            end if;
         when R2 =>
            if (button_e_out = '1') then
                next_state <= Reset;
            elsif (button_n_out = '1' or button_s_out = '1' or button_w_out = '1') then
                next_state <= W3;
                
            end if;
         when R3 =>
            if (button_e_out = '1') then
                next_state <= Reset;
            elsif (button_n_out = '1' or button_s_out = '1' or button_w_out = '1') then
                next_state <= Alarm;
                
                
            end if;
         when A1 =>
            if (button_e_out = '1') then
                next_state <= Reset;
            elsif (button_n_out = '1' or button_s_out = '1' or button_w_out = '1') then
                next_state <= Alarm;
            end if;
         when Alarm =>
            if (button_w_out = '1') then
                next_state <= A1;
            end if;
         when Reset =>
            next_state<=LOCK;
        when Unlock=>
            if (button_n_out = '1' or button_e_out = '1' or button_s_out = '1' or button_w_out = '1') then
                next_state <= LOCK;
            end if;
        end case;
    end if;


end process;

task: process(clk) --control LED's and flags
begin

if (rising_edge(clk)) then
if (current_state=S1 or current_state=W1 or current_state=R1) then
    led0<='1';
elsif (current_state=LOCK or current_state=A1) then
    led0<='0';
    led1<='0';
    led2<='0';
elsif (current_state=S2 or current_state=W2 or current_state=R2) then
    led1<='1';
elsif (current_state=W3 or current_state=S3 or current_state=R3) then
    led2<='1';
elsif (current_state=Alarm) then
    if (alarm_flag='0') then
      alarm_flag<='1';
      led1<='0';
   else
        alarm_led(2)<= not alarm_led(2);
        alarm_led(0)<= not alarm_led(0);
        led0<=alarm_led(0);
        led2<=alarm_led(2);
   end if;
elsif (current_state=Unlock) then
    if (flash_flag='0') then
        flash_flag<='1';
        led1<='0';
        led2<='0';
    else
        flash_led(0) <= not flash_led(0);
        led0<=flash_led(0);
     end if;
elsif (current_state=Reset) then
    led0<='0';
    led1<='0';
    led2<='0';
    flash_flag<='0';
    alarm_flag<='0';
end if;


end if;

end process;

end Behavioral;
