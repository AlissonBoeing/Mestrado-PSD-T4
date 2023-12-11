--Testbench for out square root calculator design.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--empty entity as its a testbench
entity sqrt_example_tb is
end sqrt_example_tb;

architecture sim of sqrt_example_tb is

    --Declare the component which we want to test.
    component SqrtExample is
        generic(N : integer := 32);
        port (
            Clk : in std_logic;
            rst : in std_logic;
            input : in unsigned(N-1 downto 0);
            done : out std_logic;
            sq_root : out unsigned(N/2-1 downto 0)
        );
    end component;

    constant clk_period : time := 10 ns;    --set the clock period for simulation.
    constant N : integer := 16;    --width of the input.
    signal Clk,rst,done : std_logic := '0';
    signal input : unsigned(N-1 downto 0) := (others => '0');
    signal sq_root : unsigned(N/2-1 downto 0) := (others => '0');
    signal error : integer := 0;    --this indicates the number of errors encountered during simulation.
    

begin

    Clk <= not Clk after clk_period / 2;    --generate clock by toggling 'Clk'.

    --entity instantiation.
    DUT : entity work.SqrtExample generic map(N => N)
             port map(Clk,rst,input,done,sq_root);

    --Apply the inputs to the design and check if the results are correct. 
    --The number of inputs for which the results were wrongly calculated are counted by 'error'.     
    SEQUENCER_PROC : process
        variable actual_result,i : integer := 1194;
    begin
        --First we apply reset input for one clock period.
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        --Test the design for all the combination of inputs.
        --Since we have (2^16)-1 inputs, we test all of them one by one. 
        while(i <= 2**N-1) loop
            input <= to_unsigned(i,N);  --convert 'i' from integer to unsigned format.
            wait until done='1';    --wait until the 'done' output signal goes high.
            wait until falling_edge(Clk);   --we sample the output at the falling edge of the clock.
            actual_result := integer(floor(sqrt(real(i)))); --Calculate the actual result.
            --if actual result and calculated result are different increment 'error' by 1.
            if (actual_result /= to_integer(sq_root)) then  
                error <= error + 1;
            end if; 
            i := i+1;   --increment the loop index.
        end loop;
        rst <= '1';   --all inputs are tested. Apply reset
        input <= (others => '0');   --reset the 'input'
        wait;
    end process;

end architecture;