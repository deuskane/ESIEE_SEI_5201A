-------------------------------------------------------------------------------
-- Title      : tb_safety_ecc
-- Project    : asylum-utils-pkg
-------------------------------------------------------------------------------
-- Description: Testbench dedicated to the ECC algorithm.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library asylum;
use asylum.safety_pkg.all;

entity tb_safety_ecc is
end entity tb_safety_ecc;

architecture sim of tb_safety_ecc is

  constant C_SCOPE  : string := "TB_SAFETY_ECC";
  constant DATA_VAL : std_logic_vector(3 downto 0) := "1010";

  signal data_i    : std_logic_vector(3 downto 0) := (others => '0');
  signal enc_o     : std_logic_vector(7 downto 0);
  signal dec_i     : std_logic_vector(7 downto 0);
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
    generic map (SAFETY_ALGO => USE_ECC)
    port map (
      data_i => data_i,
      data_o => enc_o
    );

  dec_inst : safety_dec
    generic map (SAFETY_ALGO => USE_ECC)
    port map (
      data_i            => dec_i,
      data_o            => dec_o,
      error_detected_o  => det_o,
      error_corrected_o => corr_o
    );

  stim_proc : process is
    variable v_data : std_logic_vector(7 downto 0) := (others => '0');
    variable v_res  : integer;
  begin
    log(ID_LOG_HDR, "START: ECC algorithm", C_SCOPE);

    data_i <= DATA_VAL;
    wait for 1 ns;
    dec_i <= enc_o;
    wait for 1 ns;
    check_status("[ALGO ECC] no error", '0', '0', det_o, corr_o);
    assert dec_o = DATA_VAL report "ECC output mismatch without error" severity failure;

    for i in 0 to 7 loop
      v_data := enc_o;
      flip_bit(v_data, i);
      dec_i <= v_data;
      wait for 1 ns;
      check_status("[ALGO ECC] 1 error bit " & integer'image(i), '1', '1', det_o, corr_o);
      assert dec_o = DATA_VAL report "ECC output mismatch asafetyer single-bit correction (bit " & integer'image(i) & ")" severity failure;
    end loop;

    for i in 0 to 6 loop
      for j in i + 1 to 7 loop
        v_data := enc_o;
        flip_bit(v_data, i);
        flip_bit(v_data, j);
        dec_i <= v_data;
        wait for 1 ns;
        check_status("[ALGO ECC] 2 errors bits " & integer'image(i) & "," & integer'image(j), '1', '0', det_o, corr_o);
      end loop;
    end loop;

    log_step("[ALGO ECC] Size");
    v_res := 1 + 2 + 1;
    assert encoded_size(1, SAFETY_ECC) = v_res report "Size missmatch for SAFETY_ECC and len=" & integer'image(1) severity failure;
    assert decoded_size(v_res, SAFETY_ECC) = 1 report "Decoded size missmatch for SAFETY_ECC and len=" & integer'image(1) severity failure;
    for i in 2 to 4 loop
      v_res := i + 3 + 1;
      assert encoded_size(i, SAFETY_ECC) = v_res report "Size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
      assert decoded_size(v_res, SAFETY_ECC) = i report "Decoded size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
    end loop;
    for i in 5 to 11 loop
      v_res := i + 4 + 1;
      assert encoded_size(i, SAFETY_ECC) = v_res report "Size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
      assert decoded_size(v_res, SAFETY_ECC) = i report "Decoded size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
    end loop;
    for i in 12 to 26 loop
      v_res := i + 5 + 1;
      assert encoded_size(i, SAFETY_ECC) = v_res report "Size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
      assert decoded_size(v_res, SAFETY_ECC) = i report "Decoded size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
    end loop;
    for i in 27 to 57 loop
      v_res := i + 6 + 1;
      assert encoded_size(i, SAFETY_ECC) = v_res report "Size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
      assert decoded_size(v_res, SAFETY_ECC) = i report "Decoded size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
    end loop;
    for i in 58 to 120 loop
      v_res := i + 7 + 1;
      assert encoded_size(i, SAFETY_ECC) = v_res report "Size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
      assert decoded_size(v_res, SAFETY_ECC) = i report "Decoded size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
    end loop;
    for i in 121 to 247 loop
      v_res := i + 8 + 1;
      assert encoded_size(i, SAFETY_ECC) = v_res report "Size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
      assert decoded_size(v_res, SAFETY_ECC) = i report "Decoded size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
    end loop;
    for i in 248 to 502 loop
      v_res := i + 9 + 1;
      assert encoded_size(i, SAFETY_ECC) = v_res report "Size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
      assert decoded_size(v_res, SAFETY_ECC) = i report "Decoded size missmatch for SAFETY_ECC and len=" & integer'image(i) severity failure;
    end loop;

    log_step("PASS: ECC validated");
    wait;
  end process stim_proc;

end architecture sim;
