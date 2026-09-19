-------------------------------------------------------------------------------
-- Title      : safety_dff
-- Project    : asylum-utils-pkg
-------------------------------------------------------------------------------
-- Description: Generic SAFETY wrapper with safety_enc -> register -> safety_dec.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library asylum;
use asylum.safety_pkg.all;

entity safety_dff is
    generic (
        WIDTH             : natural   := 32;
        SAFETY_ALGO       : safety_algo_t := USE_NONE;
        SELF_REFRESH      : boolean   := false
    );
    port (
        clk_i             : in  std_logic;
        arst_b_i          : in  std_logic;
        we_i              : in  std_logic;

        data_i            : in  std_logic_vector(WIDTH - 1 downto 0);
        data_o            : out std_logic_vector(WIDTH - 1 downto 0);

        error_detected_o  : out std_logic;
        error_corrected_o : out std_logic
    );
end entity safety_dff;

architecture rtl of safety_dff is
    constant WIDTH_ENC       : natural := encoded_size(WIDTH,SAFETY_ALGO);
    signal   data_enc        : std_logic_vector(WIDTH_ENC-1 downto 0);
    signal   data_dec        : std_logic_vector(WIDTH    -1 downto 0);
    signal   data_enc_r      : std_logic_vector(WIDTH_ENC-1 downto 0);
    signal   data_enc_r_next : std_logic_vector(WIDTH_ENC-1 downto 0);
    -- Prevent synthesis from simplifying/optimizing these signals away
    attribute syn_preserve   : boolean;
    attribute syn_preserve of data_enc_r      : signal is true;
begin

    enc_inst : safety_enc
        generic map (SAFETY_ALGO => SAFETY_ALGO)
        port map (
            data_i            => data_i
           ,data_o            => data_enc
        );

    gen_self_refresh   : if SELF_REFRESH = true
    generate
        data_enc_r_next <= data_enc when we_i = '1' else data_dec;
    end generate;

    gen_self_refresh_b : if SELF_REFRESH = false
    generate
        data_enc_r_next <= data_enc when we_i = '1' else data_enc_r;
    end generate;

    process (clk_i, arst_b_i)
    begin
        if arst_b_i = '0'
        then
            data_enc_r <= (others => '0');
        elsif rising_edge(clk_i) 
        then
            data_enc_r <= data_enc_r_next;
        end if;
    end process;

    dec_inst : safety_dec
        generic map (SAFETY_ALGO => SAFETY_ALGO)
        port map (
            data_i            => data_enc_r
           ,data_o            => data_dec
           ,error_detected_o  => error_detected_o
           ,error_corrected_o => error_corrected_o
        );

    data_o <= data_dec;

end architecture rtl;
