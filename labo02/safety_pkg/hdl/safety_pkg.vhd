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

package safety_pkg is

    ---------------------------------------------------------------------------
    -- Fault Tolerance definitions for overloading
    ---------------------------------------------------------------------------
    type safety_none_t        is (SAFETY_NONE       );
    type safety_parity_odd_t  is (SAFETY_PARITY_ODD );
    type safety_parity_even_t is (SAFETY_PARITY_EVEN);
    type safety_tmr_t         is (SAFETY_TMR        );
    type safety_ecc_t         is (SAFETY_ECC        );

    type safety_algo_t        is (USE_NONE
                             ,USE_PARITY_ODD
                             ,USE_PARITY_EVEN
                             ,USE_TMR
                             ,USE_ECC
                             );
    ---------------------------------------------------------------------------
    -- Type for returning status of the decoding operation
    ---------------------------------------------------------------------------

    type safety_status_t is record
        error_detected  : std_logic;
        error_corrected : std_logic;
    end record safety_status_t;

    type safety_dec_t    is record
        status          : safety_status_t;
        data            : std_logic_vector;
    end record safety_dec_t;

    ---------------------------------------------------------------------------
    -- Size Functions
    ---------------------------------------------------------------------------
    function encoded_size(data_len : natural; safety : safety_algo_t       ) return natural;
    function encoded_size(data_len : natural; safety : safety_none_t       ) return natural;
    function encoded_size(data_len : natural; safety : safety_parity_odd_t ) return natural;
    function encoded_size(data_len : natural; safety : safety_parity_even_t) return natural;
    function encoded_size(data_len : natural; safety : safety_ecc_t        ) return natural;
    function encoded_size(data_len : natural; safety : safety_tmr_t        ) return natural;

    function decoded_size(data_len : natural; safety : safety_algo_t       ) return natural;
    function decoded_size(data_len : natural; safety : safety_none_t       ) return natural;
    function decoded_size(data_len : natural; safety : safety_parity_odd_t ) return natural;
    function decoded_size(data_len : natural; safety : safety_parity_even_t) return natural;
    function decoded_size(data_len : natural; safety : safety_ecc_t        ) return natural;
    function decoded_size(data_len : natural; safety : safety_tmr_t        ) return natural;

    ---------------------------------------------------------------------------
    -- Encode Functions
    ---------------------------------------------------------------------------
    function encode(data : std_logic_vector; safety : safety_algo_t       ) return std_logic_vector;
    function encode(data : std_logic_vector; safety : safety_none_t       ) return std_logic_vector;
    function encode(data : std_logic_vector; safety : safety_parity_odd_t ) return std_logic_vector;
    function encode(data : std_logic_vector; safety : safety_parity_even_t) return std_logic_vector;
    function encode(data : std_logic_vector; safety : safety_ecc_t        ) return std_logic_vector;
    function encode(data : std_logic_vector; safety : safety_tmr_t        ) return std_logic_vector;

    ---------------------------------------------------------------------------
    -- Decode Functions
    -- Return : error_corrected & error_detected & decoded_data
    ---------------------------------------------------------------------------
    function decode(data_enc : std_logic_vector; safety : safety_algo_t       ) return safety_dec_t;
    function decode(data_enc : std_logic_vector; safety : safety_none_t       ) return safety_dec_t;
    function decode(data_enc : std_logic_vector; safety : safety_parity_odd_t ) return safety_dec_t;
    function decode(data_enc : std_logic_vector; safety : safety_parity_even_t) return safety_dec_t;
    function decode(data_enc : std_logic_vector; safety : safety_ecc_t        ) return safety_dec_t;
    function decode(data_enc : std_logic_vector; safety : safety_tmr_t        ) return safety_dec_t;

    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_algo_t       ; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic);
    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_none_t       ; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic);
    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_parity_odd_t ; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic);
    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_parity_even_t; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic);
    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_ecc_t        ; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic);
    procedure decode(signal data_enc : in std_logic_vector; safety : in safety_tmr_t        ; signal data_dec : out std_logic_vector; signal error_detected : out std_logic; signal error_corrected : out std_logic);

    ---------------------------------------------------------------------------
    -- Component Declarations
    ---------------------------------------------------------------------------
    -- [COMPONENT_INSERT][BEGIN]
component safety_dec is
    generic 
    (
        SAFETY_ALGO           : safety_algo_t := USE_NONE
    );
    port (
        data_i            : in  std_logic_vector
       ;data_o            : out std_logic_vector
       ;error_detected_o  : out std_logic
       ;error_corrected_o : out std_logic
    );
end component safety_dec;

component safety_dff is
    generic (
        WIDTH             : natural   := 32;
        SAFETY_ALGO           : safety_algo_t := USE_NONE;
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
end component safety_dff;

component safety_enc is
    generic 
    (
        SAFETY_ALGO    : safety_algo_t := USE_NONE
    );
    port (
        data_i     : in  std_logic_vector
       ;data_o     : out std_logic_vector
    );
end component safety_enc;

-- [COMPONENT_INSERT][END]
end package safety_pkg;
