-------------------------------------------------------------------------------
-- Title      : safety_enc
-- Project    :
-------------------------------------------------------------------------------
-- Description: Encoder for Fault Tolerance
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

entity safety_enc is
    generic 
    (
        SAFETY_ALGO    : safety_algo_t := USE_NONE
    );
    port (
        data_i     : in  std_logic_vector
       ;data_o     : out std_logic_vector
    );
end entity safety_enc;

architecture rtl of safety_enc is
begin

    data_o <= encode(data_i,SAFETY_ALGO);

end architecture rtl;
