-------------------------------------------------------------------------------
-- Title      : tb_safety_none
-- Project    : asylum-utils-pkg
-------------------------------------------------------------------------------
-- Description: Testbench dedicated to the NONE fault-tolerance algorithm.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library asylum;
use asylum.safety_pkg.all;

entity tb_safety_none is
end entity tb_safety_none;

architecture sim of tb_safety_none is

  constant C_SCOPE  : string := "TB_SAFETY_NONE";
  constant DATA_VAL : std_logic_vector(3 downto 0) := "1010";

  signal data_i    : std_logic_vector(3 downto 0) := (others => '0');
  signal enc_o     : std_logic_vector(3 downto 0);
  signal dec_i     : std_logic_vector(3 downto 0);
  signal dec_o     : std_logic_vector(3 downto 0);
  signal det_o     : std_logic;
  signal corr_o    : std_logic;

  procedure check_status(
    constant msg              : in string;
    constant exp_detected     : in std_logic;
    constant exp_corrected    : in std_logic;
    constant actual_detected  : in std_logic;
    constant actual_corrected : in std_logic
  ) is
  begin
    log(ID_LOG_HDR, msg, C_SCOPE);
    check_value(actual_detected, exp_detected, ERROR, msg & " detect");
    check_value(actual_corrected, exp_corrected, ERROR, msg & " correct");
  end procedure check_status;

  procedure log_step(constant msg : in string) is
  begin
    log(ID_LOG_HDR, msg, C_SCOPE);
  end procedure log_step;

  procedure flip_bit(variable v : inout std_logic_vector; idx : in natural) is
  begin
    v(idx) := not v(idx);
  end procedure flip_bit;

begin

  enc_inst : safety_enc
    generic map (SAFETY_ALGO => USE_NONE)
    port map (
      data_i  => data_i,
      data_o  => enc_o
    );

  dec_inst : safety_dec
    generic map (SAFETY_ALGO => USE_NONE)
    port map (
      data_i            => dec_i,
      data_o            => dec_o,
      error_detected_o  => det_o,
      error_corrected_o => corr_o
    );

  stim_proc : process is
    variable v_data : std_logic_vector(3 downto 0) := DATA_VAL;
    variable v_res  : integer;
  begin
    log(ID_LOG_HDR, "START: NONE algorithm", C_SCOPE);

    data_i <= DATA_VAL;
    wait for 1 ns;
    dec_i <= enc_o;
    wait for 1 ns;
    check_status("[ALGO NONE] no error", '0', '0', det_o, corr_o);
    assert dec_o = DATA_VAL report "NONE output mismatch without error" severity failure;

    v_data := enc_o;
    flip_bit(v_data, 0);
    dec_i <= v_data;
    wait for 1 ns;
    check_status("[ALGO NONE] 1 error", '0', '0', det_o, corr_o);

    v_data := enc_o;
    flip_bit(v_data, 0);
    flip_bit(v_data, 2);
    dec_i <= v_data;
    wait for 1 ns;
    check_status("[ALGO NONE] 2 errors", '0', '0', det_o, corr_o);

    v_data := enc_o;
    flip_bit(v_data, 0);
    flip_bit(v_data, 2);
    flip_bit(v_data, 3);
    dec_i <= v_data;
    wait for 1 ns;
    check_status("[ALGO NONE] 3 errors", '0', '0', det_o, corr_o);

    log_step("[ALGO NONE] Size");
    for i in 1 to 100 loop
      v_res := i;
      assert encoded_size(i, SAFETY_NONE) = v_res report "Size missmatch for SAFETY_NONE and len=" & integer'image(i) severity failure;
      assert decoded_size(v_res, SAFETY_NONE) = i report "Decoded size missmatch for SAFETY_NONE and len=" & integer'image(i) severity failure;
    end loop;

    log_step("PASS: NONE validated");
    wait;
  end process stim_proc;

end architecture sim;
