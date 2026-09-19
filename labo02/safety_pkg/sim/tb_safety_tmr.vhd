-------------------------------------------------------------------------------
-- Title      : tb_safety_tmr
-- Project    : asylum-utils-pkg
-------------------------------------------------------------------------------
-- Description: Testbench dedicated to the TMR algorithm.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library asylum;
use asylum.safety_pkg.all;

entity tb_safety_tmr is
end entity tb_safety_tmr;

architecture sim of tb_safety_tmr is

  constant C_SCOPE  : string := "TB_SAFETY_TMR";
  constant DATA_VAL : std_logic_vector(3 downto 0) := "1010";

  signal data_i    : std_logic_vector(3 downto 0) := (others => '0');
  signal enc_o     : std_logic_vector(11 downto 0);
  signal dec_i     : std_logic_vector(11 downto 0);
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
    generic map (SAFETY_ALGO => USE_TMR)
    port map (
      data_i  => data_i,
      data_o  => enc_o
    );

  dec_inst : safety_dec
    generic map (SAFETY_ALGO => USE_TMR)
    port map (
      data_i            => dec_i,
      data_o            => dec_o,
      error_detected_o  => det_o,
      error_corrected_o => corr_o
    );

  stim_proc : process is
    variable v_data : std_logic_vector(11 downto 0) := (others => '0');
    variable v_res  : integer;
  begin
    log(ID_LOG_HDR, "START: TMR algorithm", C_SCOPE);

    data_i <= DATA_VAL;
    wait for 1 ns;
    dec_i <= enc_o;
    wait for 1 ns;
    check_status("[ALGO TMR] no error", '0', '0', det_o, corr_o);
    assert dec_o = DATA_VAL report "TMR output mismatch without error" severity failure;

    for i in 0 to 11 loop
      v_data := enc_o;
      flip_bit(v_data, i);
      dec_i <= v_data;
      wait for 1 ns;
      check_status("[ALGO TMR] 1 error bit " & integer'image(i), '1', '1', det_o, corr_o);
      assert dec_o = DATA_VAL report "TMR output mismatch asafetyer single-bit correction (bit " & integer'image(i) & ")" severity failure;
    end loop;

    for i in 0 to 1 loop
      for j in i + 1 to 2 loop
        v_data := enc_o;
        flip_bit(v_data, i);
        flip_bit(v_data, j);
        dec_i <= v_data;
        wait for 1 ns;
        check_status("[ALGO TMR] 2 errors bits " & integer'image(i) & "," & integer'image(j), '1', '1', det_o, corr_o);
        assert dec_o = DATA_VAL report "TMR output mismatch asafetyer two-bit correction (bits " & integer'image(i) & "," & integer'image(j) & ")" severity failure;
      end loop;
    end loop;

    v_data := enc_o;
    flip_bit(v_data, 0);
    flip_bit(v_data, 1);
    flip_bit(v_data, 2);
    dec_i <= v_data;
    wait for 1 ns;
    check_status("[ALGO TMR] 3 errors bits 0,1,2", '1', '1', det_o, corr_o);
    assert dec_o = DATA_VAL report "TMR output mismatch asafetyer three-bit correction" severity failure;

    log_step("[ALGO TMR] Size");
    for i in 1 to 100 loop
      v_res := i * 3;
      assert encoded_size(i, SAFETY_TMR) = v_res report "Size missmatch for SAFETY_TMR and len=" & integer'image(i) severity failure;
      assert decoded_size(v_res, SAFETY_TMR) = i report "Decoded size missmatch for SAFETY_TMR and len=" & integer'image(i) severity failure;
    end loop;

    log_step("PASS: TMR validated");
    wait;
  end process stim_proc;

end architecture sim;
