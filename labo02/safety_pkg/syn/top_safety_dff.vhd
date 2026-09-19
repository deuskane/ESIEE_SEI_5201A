-------------------------------------------------------------------------------
-- Title      : top_safety_dff
-- Project    : asylum-utils-pkg
-------------------------------------------------------------------------------
-- Description: Safety wrapper with input/output pipelining around safety_dff.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library asylum;
use     asylum.safety_pkg.all;

entity top_safety_dff is
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
end entity top_safety_dff;

architecture rtl of top_safety_dff is
    signal we_i_r        : std_logic;
    signal data_i_r      : std_logic_vector(WIDTH - 1 downto 0);
    signal data_o_r      : std_logic_vector(WIDTH - 1 downto 0);
    signal err_det_r     : std_logic;
    signal err_cor_r     : std_logic;
begin

    process (clk_i, arst_b_i)
    begin
        if arst_b_i = '0' then
            we_i_r   <= '0';
            data_i_r <= (others => '0');
        elsif rising_edge(clk_i) then
            we_i_r   <= we_i;
            data_i_r <= data_i;
        end if;
    end process;

    safety_dff_inst : safety_dff
        generic map (
            WIDTH        => WIDTH,
            SAFETY_ALGO  => SAFETY_ALGO,
            SELF_REFRESH => SELF_REFRESH
        )
        port map (
            clk_i            => clk_i,
            arst_b_i         => arst_b_i,
            we_i             => we_i_r,
            data_i           => data_i_r,
            data_o           => data_o_r,
            error_detected_o => err_det_r,
            error_corrected_o=> err_cor_r
        );

    process (clk_i, arst_b_i)
    begin
        if arst_b_i = '0' then
            data_o            <= (others => '0');
            error_detected_o  <= '0';
            error_corrected_o <= '0';
        elsif rising_edge(clk_i) then
            data_o            <= data_o_r;
            error_detected_o  <= err_det_r;
            error_corrected_o <= err_cor_r;
        end if;
    end process;

end architecture rtl;
