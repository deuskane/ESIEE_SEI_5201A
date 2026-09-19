-------------------------------------------------------------------------------
-- Title      : safety_pkg
-- Project    :
-------------------------------------------------------------------------------
-- Description: Fault Tolerance Package
-------------------------------------------------------------------------------
-- Copyright (c) 2026
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-07-07  1.0      mrosiere Created
-- 2026-09-08  1.1      mrosiere Add decoded_size function
--                               Add decode procedure
-------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library asylum;
use     asylum.logic_pkg.all;
use     asylum.math_pkg.all;
use     asylum.safety_pkg.all;

package body safety_pkg is

    ---------------------------------------------------------------------------
    -- ENCODED SIZE IMPLEMENTATION
    ---------------------------------------------------------------------------
    function encoded_size(data_len : natural; safety : safety_algo_t) return natural is
    begin
        case safety is
            when USE_NONE        =>
                return encoded_size(data_len, SAFETY_NONE);
            when USE_PARITY_ODD  =>
                return encoded_size(data_len, SAFETY_PARITY_ODD);
            when USE_PARITY_EVEN =>
                return encoded_size(data_len, SAFETY_PARITY_EVEN);
            when USE_ECC         =>
                return encoded_size(data_len, SAFETY_ECC);
            when USE_TMR         =>
                return encoded_size(data_len, SAFETY_TMR);
            when others          =>
                assert false report "encoded_size: unknown safety_algo_t: " & safety_algo_t'IMAGE(safety) severity failure;
                return 0;
        end case;
    end function;

    function encoded_size(data_len : natural; safety : safety_none_t) return natural is
    begin
        return data_len;
    end function;

    function encoded_size(data_len : natural; safety : safety_parity_odd_t) return natural is
    begin
        -- TODO
        return encoded_size(data_len,SAFETY_NONE);
    end function;

    function encoded_size(data_len : natural; safety : safety_parity_even_t) return natural is
    begin
        -- TODO
        return encoded_size(data_len,SAFETY_NONE);
    end function;

    function encoded_size(data_len : natural; safety : safety_ecc_t) return natural is
    begin
        -- TODO
        return encoded_size(data_len,SAFETY_NONE);
    end function;

    function encoded_size(data_len : natural; safety : safety_tmr_t) return natural is
    begin
        -- TODO
        return encoded_size(data_len,SAFETY_NONE);
    end function;

    ---------------------------------------------------------------------------
    -- DECODED SIZE IMPLEMENTATION
    ---------------------------------------------------------------------------
    function decoded_size(data_len : natural; safety : safety_algo_t) return natural is
    begin
        case safety is
            when USE_NONE        =>
                return decoded_size(data_len, SAFETY_NONE);
            when USE_PARITY_ODD  =>
                return decoded_size(data_len, SAFETY_PARITY_ODD);
            when USE_PARITY_EVEN =>
                return decoded_size(data_len, SAFETY_PARITY_EVEN);
            when USE_ECC         =>
                return decoded_size(data_len, SAFETY_ECC);
            when USE_TMR         =>
                return decoded_size(data_len, SAFETY_TMR);
            when others          =>
                assert false report "decoded_size: unknown safety_algo_t: " & safety_algo_t'IMAGE(safety) severity failure;
                return 0;
        end case;
    end function;
    
    function decoded_size(data_len : natural; safety : safety_none_t) return natural is
    begin
        return data_len;
    end function;

    function decoded_size(data_len : natural; safety : safety_parity_odd_t) return natural is
    begin
        -- TODO
        return decoded_size(data_len,SAFETY_NONE);
    end function;

    function decoded_size(data_len : natural; safety : safety_parity_even_t) return natural is
    begin
        -- TODO
        return decoded_size(data_len,SAFETY_NONE);
    end function;

    function decoded_size(data_len : natural; safety : safety_ecc_t) return natural is
    begin
        -- TODO
        return decoded_size(data_len,SAFETY_NONE);
    end function;

    function decoded_size(data_len : natural; safety : safety_tmr_t) return natural is
    begin
        -- TODO
        return decoded_size(data_len,SAFETY_NONE);
    end function;

    ---------------------------------------------------------------------------
    -- ENCODE IMPLEMENTATION
    ---------------------------------------------------------------------------
    function encode(data : std_logic_vector; safety : safety_algo_t) return std_logic_vector is
    begin
        case safety is
            when USE_NONE        =>
                return encode(data, SAFETY_NONE);
            when USE_PARITY_ODD  =>
                return encode(data, SAFETY_PARITY_ODD);
            when USE_PARITY_EVEN =>
                return encode(data, SAFETY_PARITY_EVEN);
            when USE_ECC         =>
                return encode(data, SAFETY_ECC);
            when USE_TMR         =>
                return encode(data, SAFETY_TMR);
            when others          =>
                assert false report "encode: unknown safety_algo_t: " & safety_algo_t'IMAGE(safety) severity failure;
                return encode(data, SAFETY_NONE);
        end case;
    end function;

    function encode(data : std_logic_vector; safety : safety_none_t) return std_logic_vector is
    begin
        -- No redundancy
        return data;
    end function;

    function encode(data : std_logic_vector; safety : safety_parity_odd_t) return std_logic_vector is
    begin
        -- TODO
        return encode(data,SAFETY_NONE);

    end function;

    function encode(data : std_logic_vector; safety : safety_parity_even_t) return std_logic_vector is
    begin
        -- TODO
        return encode(data,SAFETY_NONE);
    end function;

    function encode(data : std_logic_vector; safety : safety_tmr_t) return std_logic_vector is
    begin
        -- TODO
        return encode(data,SAFETY_NONE);
    end function;

    function encode(data : std_logic_vector; safety : safety_ecc_t) return std_logic_vector is
    begin
        -- TODO
        return encode(data,SAFETY_NONE);
    end function;

    ---------------------------------------------------------------------------
    -- DECODE Function IMPLEMENTATION 
    ---------------------------------------------------------------------------
    function decode(data_enc : std_logic_vector; safety : safety_algo_t) return safety_dec_t is
    begin
        case safety is
            when USE_NONE        =>
                return decode(data_enc, SAFETY_NONE);
            when USE_PARITY_ODD  =>
                return decode(data_enc, SAFETY_PARITY_ODD);
            when USE_PARITY_EVEN =>
                return decode(data_enc, SAFETY_PARITY_EVEN);
            when USE_ECC         =>
                return decode(data_enc, SAFETY_ECC);
            when USE_TMR         =>
                return decode(data_enc, SAFETY_TMR);
            when others          =>
                assert false report "decode: unknown safety_algo_t: " & safety_algo_t'IMAGE(safety) severity failure;
                return decode(data_enc, SAFETY_NONE);
        end case;
    end function;

    function decode(data_enc : std_logic_vector; safety : safety_none_t) return safety_dec_t is
        variable ret : safety_dec_t(data(data_enc'length - 1 downto 0));
    begin
        ret.status.error_detected  := '0';
        ret.status.error_corrected := '0';
        ret.data                   := data_enc;
        return ret;
    end function;
    
    function decode(data_enc : std_logic_vector; safety : safety_parity_odd_t) return safety_dec_t is
    begin
        -- TODO
        return decode(data_enc,SAFETY_NONE);
    end function;

    function decode(data_enc : std_logic_vector; safety : safety_parity_even_t) return safety_dec_t is
    begin
        -- TODO
        return decode(data_enc,SAFETY_NONE);
    end function;

    function decode(data_enc : std_logic_vector; safety : safety_tmr_t) return safety_dec_t is
    begin
        -- TODO
        return decode(data_enc,SAFETY_NONE);
    end function;

    function decode(data_enc : std_logic_vector; safety : safety_ecc_t) return safety_dec_t is
    begin
        -- TODO
        return decode(data_enc,SAFETY_NONE);
    end function;

    ---------------------------------------------------------------------------
    -- DECODE Procedure IMPLEMENTATION 
    ---------------------------------------------------------------------------
    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_algo_t; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic) is
        variable ret : safety_dec_t(data(decoded_size(data_enc'length,safety) - 1 downto 0));
    begin
        ret := decode(data_enc, safety);
        data_dec        <= ret.data;
        error_detected  <= ret.status.error_detected;
        error_corrected <= ret.status.error_corrected;
    end procedure decode;
    
    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_none_t; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic) is
        variable ret : safety_dec_t(data(decoded_size(data_enc'length,safety) - 1 downto 0));
    begin
        ret := decode(data_enc, safety);
        data_dec        <= ret.data;
        error_detected  <= ret.status.error_detected;
        error_corrected <= ret.status.error_corrected;
    end procedure decode;

    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_parity_odd_t; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic) is
        variable ret : safety_dec_t(data(decoded_size(data_enc'length,safety) - 1 downto 0));
    begin
        ret := decode(data_enc, safety);
        data_dec        <= ret.data;
        error_detected  <= ret.status.error_detected;
        error_corrected <= ret.status.error_corrected;
    end procedure decode;

    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_parity_even_t; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic) is
        variable ret : safety_dec_t(data(decoded_size(data_enc'length,safety) - 1 downto 0));
    begin
        ret := decode(data_enc, safety);
        data_dec        <= ret.data;
        error_detected  <= ret.status.error_detected;
        error_corrected <= ret.status.error_corrected;
    end procedure decode;

    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_ecc_t; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic) is
        variable ret : safety_dec_t(data(decoded_size(data_enc'length,safety) - 1 downto 0));
    begin
        ret := decode(data_enc, safety);
        data_dec        <= ret.data;
        error_detected  <= ret.status.error_detected;
        error_corrected <= ret.status.error_corrected;
    end procedure decode;

    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_tmr_t; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic) is
        variable ret : safety_dec_t(data(decoded_size(data_enc'length,safety) - 1 downto 0));
    begin
        ret := decode(data_enc, safety);
        data_dec        <= ret.data;
        error_detected  <= ret.status.error_detected;
        error_corrected <= ret.status.error_corrected;
    end procedure decode;

end package body safety_pkg;