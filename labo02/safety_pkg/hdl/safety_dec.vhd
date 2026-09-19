-------------------------------------------------------------------------------
-- Title      : safety_dec
-- Project    :
-------------------------------------------------------------------------------
-- Description: Decoder for Fault Tolerance
-------------------------------------------------------------------------------
-- Copyright (c) 2026
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-07-15  1.0      mrosiere Created
-------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library asylum;
use     asylum.safety_pkg.all;

entity safety_dec is
    generic 
    (
        SAFETY_ALGO       : safety_algo_t := USE_NONE
    );
    port (
        data_i            : in  std_logic_vector
       ;data_o            : out std_logic_vector
       ;error_detected_o  : out std_logic
       ;error_corrected_o : out std_logic
    );
end entity safety_dec;

architecture rtl of safety_dec is
begin
    
    process (ALL)
    begin
        decode(data_i,SAFETY_ALGO,data_o, error_detected_o, error_corrected_o);
    end process;

end architecture rtl;
