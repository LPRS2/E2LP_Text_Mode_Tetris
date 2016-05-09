----------------------------------------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije                                                --
--  Copyright © 2009 All Rights Reserved                                                                      --
--                                                                                                            --
--  Projekat:                                                                                                 --
--  Ime modula: vga_sync.vhd                                                                                  --
--  Autori: LPRS2 TIM 2009/2010 <LPRS2@rt-rk.com>                                                             --
--                                                                                                            --
--  Opis:                                                                                                     --
--                                                                                                            --
-- Ukljucuje module: /                                                                                        --
--                                                                                                            --
--   Verzija :  1.0                                                                                           --
--                                                                                                            --
--                                                                                                            --
--   PARAMETRI : horizontal_res, vertical_res                                                                 --
--                                                                                                            --
--   Ulazi: clk_i, rst_n_i                                                                                    --
--          red_i, green_i, blue_i ( signali koji pokazuju kojom bojom treba obojiti tacku )                  --
--                                                                                                            --
--    Izlazi: red_o, green_o, blue_o ( signali koji boje tacku )                                              --
--                                                                                                            --
--            horiz_sync_o, vert_sync_o, sync_o (sinhronizujuci signali)                                      --
--                                                                                                            --
--            pixel_row_o, pixel_column_o ( red_i i kolona na koju je trenutno pozicionirano iscrtavanje )    --
--                                                                                                            --
--            blank_o ( SIGNAL koji je aktivan kad treba iscrtati tacku )                                     --
--                                                                                                            --
--            psave_o, pix_clk_o                                                                              --
--                                                                                                            --
----------------------------------------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------------------------------------------------------
------------------------definisanje entiteta vga_sync-----------------------------

ENTITY vga_sync IS GENERIC (
                            horizontal_res : INTEGER :=  800;
                            vertical_res   : INTEGER :=  600
                           );
                     PORT (
                            clk_i          : IN   STD_LOGIC;                        -- takt
                            rst_n_i        : IN   STD_LOGIC;                        -- reset
                            red_i          : IN   STD_LOGIC;                        -- ulazna  vrednost crvene boje
                            green_i        : IN   STD_LOGIC;                        -- ulazna  vrednost zelene boje
                            blue_i         : IN   STD_LOGIC;                        -- ulazna  vrednost plave  boje
                            red_o          : OUT  STD_LOGIC;                        -- izlazna vrednost crvene boje
                            green_o        : OUT  STD_LOGIC;                        -- izlazna vrednost zelene boje
                            blue_o         : OUT  STD_LOGIC;                        -- izlazna vrednost plave  boje
                            pixel_row_o    : OUT  STD_LOGIC_VECTOR (10 DOWNTO 0);   -- pozicija pixela po vrstama
                            pixel_column_o : OUT  STD_LOGIC_VECTOR (10 DOWNTO 0);   -- pozicija pixela po kolonama
                            horiz_sync_o   : OUT  STD_LOGIC;                        -- horizontalna sinhronizacija
                            vert_sync_o    : OUT  STD_LOGIC;                        -- vertikalna   sinhronizacija
                            psave_o        : OUT  STD_LOGIC;                        -- signal kontrole napajanja, MORA uvek na visokom logickom nivou
                            blank_o        : OUT  STD_LOGIC;                        -- aktivni deo linije
                            pix_clk_o      : OUT  STD_LOGIC;                        -- takt sa kojim je sinhronizovano ispisivanje pixela
                            sync_o         : OUT  STD_LOGIC                         -- sjedinjena vertikalna i horizontalna sinhronizacija
                           );

END vga_sync;


ARCHITECTURE rtl OF vga_sync IS

 SIGNAL horiz_sync_r       : STD_LOGIC;
 SIGNAL vert_sync_r        : STD_LOGIC;
 SIGNAL enable_s           : STD_LOGIC;
 SIGNAL h_count_r          : STD_LOGIC_VECTOR( 10 DOWNTO 0 );
 SIGNAL v_count_r          : STD_LOGIC_VECTOR( 10 DOWNTO 0 );

 SIGNAL horiz_sync_out_d_r : STD_LOGIC;
 SIGNAL vert_sync_out_d_r  : STD_LOGIC;
 SIGNAL psave_d_r          : STD_LOGIC;
 SIGNAL blank_d_r          : STD_LOGIC;
 SIGNAL sync_d_r           : STD_LOGIC;

 -- signali za registrovanje izlaza
 SIGNAL red_r              : STD_LOGIC;
 SIGNAL green_r            : STD_LOGIC;
 SIGNAL blue_r             : STD_LOGIC;
 SIGNAL horiz_sync_out_r   : STD_LOGIC;
 SIGNAL vert_sync_out_r    : STD_LOGIC;
 SIGNAL pixel_row_r        : STD_LOGIC_VECTOR(10 DOWNTO 0);
 SIGNAL pixel_column_r     : STD_LOGIC_VECTOR(10 DOWNTO 0);
 SIGNAL psave_r            : STD_LOGIC;
 SIGNAL blank_r            : STD_LOGIC;
 SIGNAL sync_r             : STD_LOGIC;


  -- konstatne horizontalne sinhronizacije
 SIGNAL  H_PIXELS          : INTEGER RANGE 0 TO 2047;
 SIGNAL  H_FRONTPORCH      : INTEGER RANGE 0 TO 2047;
 SIGNAL  H_SYNC_TIME       : INTEGER RANGE 0 TO 2047;
 SIGNAL  H_BACKPORCH       : INTEGER RANGE 0 TO 2047;

  -- konstatne vertikalne sinhronizacije
 SIGNAL  V_LINES           : INTEGER RANGE 0 TO 2047;
 SIGNAL  V_FRONTPORCH      : INTEGER RANGE 0 TO 2047;
 SIGNAL  V_SYNC_TIME       : INTEGER RANGE 0 TO 2047;
 SIGNAL  V_BACKPORCH       : INTEGER RANGE 0 TO 2047;



BEGIN

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

-- Definisanje parametara potrebnih za sihronizacione signale
-- Ovi parametri zavise od rezolucije
res_1 : IF ( horizontal_res = 640 AND vertical_res = 480 ) GENERATE

            H_PIXELS       <= 640;
            H_FRONTPORCH   <= 16 ;
            H_SYNC_TIME    <= 96 ;
            H_BACKPORCH    <= 40 ;

            V_LINES        <= 480;
            V_FRONTPORCH   <= 11 ;
            V_SYNC_TIME    <= 2  ;
            V_BACKPORCH    <= 31 ;

       END GENERATE res_1;

res_2 : IF ( horizontal_res = 800 AND vertical_res = 600 ) GENERATE

            H_PIXELS       <= 800;
            H_FRONTPORCH   <= 56 ;
            H_SYNC_TIME    <= 120;
            H_BACKPORCH    <= 64 ;

            V_LINES        <= 600;
            V_FRONTPORCH   <= 37 ;
            V_SYNC_TIME    <= 6  ;
            V_BACKPORCH    <= 23 ;

       END GENERATE res_2;

res_3 : IF ( horizontal_res = 1024 AND vertical_res = 768 ) GENERATE

            H_PIXELS       <= 1024;
            H_FRONTPORCH   <= 24  ;
            H_SYNC_TIME    <= 136 ;
            H_BACKPORCH    <= 144 ;

            V_LINES        <= 768 ;
            V_FRONTPORCH   <= 3   ;
            V_SYNC_TIME    <= 6   ;
            V_BACKPORCH    <= 29  ;

       END GENERATE res_3;

res_4 : IF ( horizontal_res = 1152 AND vertical_res = 864 ) GENERATE

            H_PIXELS       <= 1152;
            H_FRONTPORCH   <= 64  ;
            H_SYNC_TIME    <= 128 ;
            H_BACKPORCH    <= 256 ;

            V_LINES        <= 864 ;
            V_FRONTPORCH   <= 1   ;
            V_SYNC_TIME    <= 3   ;
            V_BACKPORCH    <= 32  ;

       END GENERATE res_4;

res_5 : IF ( horizontal_res = 1280 AND vertical_res = 1024 ) GENERATE

            H_PIXELS       <= 1280;
            H_FRONTPORCH   <= 48  ;
            H_SYNC_TIME    <= 112 ;
            H_BACKPORCH    <= 248 ;

            V_LINES        <= 1024;
            V_FRONTPORCH   <= 1   ;
            V_SYNC_TIME    <= 3   ;
            V_BACKPORCH    <= 38  ;

       END GENERATE res_5;

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
--
--       |<--- Active Region --->|<----------- Blanking Region ---------->|<--- Active Region --->|<----------- Blanking Region ---------->|
--       |       (Pixels)        |                                        |       (Pixels)        |                                        |
--       |       (Lines)         |                                        |       (Lines)         |                                        |
--       |                       |                                        |                       |                                        |
--   ----+---------- ... --------+-------------             --------------+---------- ... --------+-------------             --------------+--
--   |   |                       |            |             |             |                       |            |             |             |
--   |   |                       |<--Front    |<---Sync     |<---Back     |                       |<--Front    |<---Sync     |<---Back     |
--   |   |                       |    Porch-->|     Time--->|    Porch--->|                       |    Porch-->|     Time--->|    Porch--->|
------   |                       |            ---------------             |                       |            ---------------             |
--       |                       |                                        |                       |                                        |
--       |<------------------- Period ----------------------------------->|<------------------- Period ----------------------------------->|
--
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------



-- broji od nule do pune velicine linije
PROCESS(clk_i)
BEGIN

  IF ( clk_i'EVENT AND clk_i = '1' ) THEN

      IF ( rst_n_i = '0' ) THEN  h_count_r <= (OTHERS => '0');
      ELSE
        IF   ( h_count_r < ( H_SYNC_TIME + H_PIXELS + H_FRONTPORCH + H_BACKPORCH) ) THEN  h_count_r <= h_count_r + 1;
        ELSE                                                                              h_count_r <= (OTHERS => '0');
        END IF;
      END IF;

  END IF;

END PROCESS;

-- generise hsyncb : nula je nad hor sync_o
PROCESS(clk_i)
BEGIN

 IF ( clk_i'EVENT AND clk_i = '1') THEN

   IF ( rst_n_i = '0') THEN horiz_sync_r <= '1';
   ELSE
     IF  ( (h_count_r >= (H_FRONTPORCH + H_PIXELS)) AND (h_count_r < (H_PIXELS + H_FRONTPORCH + H_SYNC_TIME) )) THEN  horiz_sync_r <= '0';
     ELSE                                                                                                             horiz_sync_r <= '1';
     END IF;
   END IF;

 END IF;

END PROCESS;

-- uvecava vcnt na rastucu ivicu hor sync_o
PROCESS(clk_i)
BEGIN

 IF (clk_i'EVENT AND clk_i = '1') THEN

     IF ( rst_n_i = '0' ) THEN   v_count_r <= (OTHERS => '0');
     ELSE
       IF ( h_count_r = H_PIXELS + H_FRONTPORCH + H_SYNC_TIME ) THEN
         IF ( v_count_r < (V_SYNC_TIME + V_LINES + V_FRONTPORCH + V_BACKPORCH) ) THEN  v_count_r <= v_count_r + 1;
         ELSE                                                                          v_count_r <= (OTHERS => '0');
         END IF;
       END IF;
    END IF;

 END IF;

END PROCESS;


PROCESS(clk_i)
BEGIN

 IF (clk_i'EVENT AND clk_i = '1') THEN

   IF ( rst_n_i = '0' ) THEN vert_sync_r <= '1';
   ELSE
     IF ( h_count_r = H_PIXELS + H_FRONTPORCH + H_SYNC_TIME ) THEN
        IF   (v_count_r >= (V_LINES + V_FRONTPORCH) AND v_count_r < (V_LINES + V_FRONTPORCH + V_SYNC_TIME)) THEN  vert_sync_r <= '0';
        ELSE                                                                                                      vert_sync_r <= '1';
        END IF;
     END IF;
   END IF;

 END IF;

END PROCESS;


PROCESS (h_count_r,v_count_r)
BEGIN
        IF ( (h_count_r >= H_PIXELS) OR (v_count_r >= V_LINES) ) THEN  enable_s <= '0';
        ELSE                                                           enable_s <= '1';
        END IF;

END PROCESS;


-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------



  -- registrovanje signala
reg_outputs_1:PROCESS (clk_i)

  BEGIN

    IF (clk_i'EVENT AND clk_i = '1') THEN

      IF (rst_n_i = '0') THEN

        horiz_sync_out_r   <= '0';
        vert_sync_out_r    <= '0';
        psave_r            <= '0';
        blank_r            <= '0';
        sync_r             <= '0';

        horiz_sync_out_d_r <= '0';
        vert_sync_out_d_r  <= '0';
        psave_d_r          <= '0';
        blank_d_r          <= '0';
        sync_d_r           <= '0';


      ELSE


         horiz_sync_out_d_r <= horiz_sync_r                ;
         vert_sync_out_d_r  <= vert_sync_r                 ;
         psave_d_r          <= '1'                         ;
         blank_d_r          <= enable_s                    ;
         sync_d_r           <= vert_sync_r AND horiz_sync_r;

         horiz_sync_out_r   <=  horiz_sync_out_d_r;
         vert_sync_out_r    <=  vert_sync_out_d_r ;
         psave_r            <=  psave_d_r         ;
         blank_r            <=  blank_d_r         ;
         sync_r             <=  sync_d_r          ;



      END IF;

    END IF;

END PROCESS reg_outputs_1;

reg_outputs_2:PROCESS (clk_i)
BEGIN

  IF (clk_i'EVENT AND clk_i = '1') THEN
   IF (rst_n_i = '0') THEN

         red_r            <= '0';
         green_r          <= '0';
         blue_r           <= '0';

   ELSE
      IF ( enable_s = '1' ) THEN

         red_r          <= red_i    ;
         green_r        <= green_i  ;
         blue_r         <= blue_i   ;

      END IF;
   END IF;
  END IF;

END PROCESS reg_outputs_2;



  -- povezivanje signala na izlaz

  red_o          <=  red_r           ;
  green_o        <=  green_r         ;
  blue_o         <=  blue_r          ;
  horiz_sync_o   <=  horiz_sync_out_r;
  vert_sync_o    <=  vert_sync_out_r ;
  pixel_row_o    <=  v_count_r       ;
  pixel_column_o <=  h_count_r       ;
  psave_o        <=  psave_r         ;
  blank_o        <=  blank_r         ;
  pix_clk_o      <=  clk_i           ;
  sync_o         <=  sync_r          ;

END rtl;

