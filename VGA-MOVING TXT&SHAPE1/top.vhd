----------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije                  --
--  Copyright © 2009 All Rights Reserved                                        --
----------------------------------------------------------------------------------
--                                                                              --
-- Autor: LPRS2 TIM 2009/2010 <LPRS2@KRT.neobee.net>                            --
--                                                                              --
-- Datum izrade: /                                                              --
-- Naziv Modula: vga.vhd                                                        --
-- Naziv projekta: LabVezba2                                                    --
--                                                                              --
-- Opis: ispisivanje vrednosti rezolucije u gornjem desnom uglu                 --
--                                                                              --
-- Ukljucuje module: vga, char_rom                                              --
--                                                                              --
-- Verzija : 1.0                                                                --
--                                                                              --
-- Dodatni komentari: /                                                         --
--                                                                              --
-- ULAZI: FPGA_CLK                                                              --
--        FPGA_RESET                                                            --
--                                                                              --
-- IZLAZI: VGA_HSYNC                                                            --
--         VGA_VSYNC                                                            --
--         BLANK                                                                --
--         PIX_CLOCK                                                            --
--         PSAVE                                                                --
--         SYNC                                                                 --
--         RED0                                                                 --
--         RED1                                                                 --
--         RED2                                                                 --
--         RED3                                                                 --
--         RED4                                                                 --
--         RED5                                                                 --
--         RED6                                                                 --
--         RED7                                                                 --
--         GREEN0                                                               --
--         GREEN1                                                               --
--         GREEN2                                                               --
--         GREEN3                                                               --
--         GREEN4                                                               --
--         GREEN5                                                               --
--         GREEN6                                                               --
--         GREEN7                                                               --
--         BLUE0                                                                --
--         BLUE1                                                                --
--         BLUE2                                                                --
--         BLUE3                                                                --
--         BLUE4                                                                --
--         BLUE5                                                                --
--         BLUE6                                                                --
--         BLUE7                                                                --
--                                                                              --
-- PARAMETRI : /                                                                --
--                                                                              --
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY top IS PORT (
                    FPGA_CLK    : IN  STD_LOGIC;  -- TAKT  sa ploce
                    FPGA_RESET  : IN  STD_LOGIC;  -- RESET sa ploce
						  
						  iHcmd		: IN STD_LOGIC;	 -- ULAZNI JOY-PAD za kretanje po horizontali
						  iVcmd		: IN STD_LOGIC;	 -- ULAZNI JOY-PAD za kretanje po vertikali
						  iHcmd1		: IN STD_LOGIC;	 -- ULAZNI JOY-PAD za kretanje po horizontali
						  iVcmd1		: IN STD_LOGIC;	 -- ULAZNI JOY-PAD za kretanje po vertikali
						  
						  crash     : OUT STD_LOGIC;
                    -- vga pinovi
                    VGA_HSYNC   : OUT STD_LOGIC;  -- signal horizontalne sinhronizacije
                    VGA_VSYNC   : OUT STD_LOGIC;  -- signal vertikalne   sinhronizacije

                    BLANK       : OUT STD_LOGIC; -- signal indikacije aktivnosti piksela
                    PIX_CLOCK   : OUT STD_LOGIC; -- takt sa kojim je sinhronizovano ispisivanje pixela
                    PSAVE       : OUT STD_LOGIC; -- signal kontrole napajanja, MORA uvek na visokom logickom nivou
                    SYNC        : OUT STD_LOGIC; -- sjedinjena vertikalna i horizontalna sinhronizacija
                    RED0        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED1        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED2        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED3        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED4        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED5        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED6        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    RED7        : OUT STD_LOGIC; -- izlaz za crvenu boju
                    GREEN0      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN1      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN2      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN3      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN4      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN5      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN6      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    GREEN7      : OUT STD_LOGIC; -- izlaz za zelenu boju
                    BLUE0       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE1       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE2       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE3       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE4       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE5       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE6       : OUT STD_LOGIC; -- izlaz za plavu  boju
                    BLUE7       : OUT STD_LOGIC  -- izlaz za plavu  boju
                   );
END top;

ARCHITECTURE rtl OF top IS

-- instanciranje komponenti

COMPONENT vga IS GENERIC (

                        -- podrzane rezolucije vga ekrana -- vrednost parametra
                       --     rezolucija 640x480         --        0
                       --     rezolucija 800x600         --        1
                       --     rezolucija 1024x768        --        2
                       --     rezolucija 1152x864        --        3
                       --     rezolucija 1280x1024       --        4
                       resolution_type : integer  := 0

                      );
              PORT(
                   clk_i          : IN  STD_LOGIC;                     -- takt
                   rst_n_i        : IN  STD_LOGIC;                     -- reset
                   red_i          : IN  STD_LOGIC;                     -- ulazna  vrednost crvene boje
                   green_i        : IN  STD_LOGIC;                     -- ulazna  vrednost zelene boje
                   blue_i         : IN  STD_LOGIC;                     -- ulazna  vrednost plave  boje
                   red_o          : OUT STD_LOGIC;                     -- izlazna vrednost crvene boje
                   green_o        : OUT STD_LOGIC;                     -- izlazna vrednost zelene boje
                   blue_o         : OUT STD_LOGIC;                     -- izlazna vrednost plave  boje
                   pixel_row_o    : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);   -- pozicija pixela po vrstama
                   pixel_column_o : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);   -- pozicija pixela po kolonama
                   hsync_o        : OUT STD_LOGIC;                       -- horizontalna sinhronizacija
                   vsync_o        : OUT STD_LOGIC;                       -- vertikalna   sinhronizacija
                   psave_o        : OUT STD_LOGIC;                     -- signal kontrole napajanja, MORA uvek na visokom logickom nivou
                   blank_o        : OUT STD_LOGIC;                       -- aktivni deo linije
                   vga_pix_clk_o  : OUT STD_LOGIC;                     -- takt sa kojim je sinhronizovano ispisivanje pixela
                   vga_rst_n_o    : OUT STD_LOGIC;                       -- reset sinhronizovan sa vga_pix_clk_o taktom
                   sync_o         : OUT STD_LOGIC                      -- sjedinjena vertikalna i horizontalna sinhronizacija
                        );
END COMPONENT vga;

COMPONENT char_rom IS PORT (
                            clk_i             	: IN   STD_LOGIC;                           -- takt signal
                            character_address_i : IN   STD_LOGIC_VECTOR (5 DOWNTO 0);       -- adresa karaktera
                            font_row_i         	: IN   STD_LOGIC_VECTOR (2 DOWNTO 0);       --
                            font_col_i          : IN   STD_LOGIC_VECTOR (2 DOWNTO 0);       --
                            rom_mux_output_o	  : OUT  STD_LOGIC                            -- izlazni signal iz char_rom-a
                           );
END COMPONENT char_rom;

-- rezolucija ekrana
SIGNAL    horizontal_res       : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL    vertical_res         : STD_LOGIC_VECTOR(10 DOWNTO 0);

-- TEXT SIGNAL

SIGNAL hor_cmd 					 : STD_LOGIC_VECTOR(10 downto 0) := "01000000000"; -- DEFAULT VALUE 512;
SIGNAL ver_cmd						 : STD_LOGIC_VECTOR(10 downto 0) := "01010000000"; -- DEFAULT VALUE 640;
SIGNAL hor_cmd1 					 : STD_LOGIC_VECTOR(10 downto 0) := "01000100110"; -- DEFAULT VALUE 512;
SIGNAL ver_cmd1						 : STD_LOGIC_VECTOR(10 downto 0) := "00101011110"; -- DEFAULT VALUE 640;

signal matching,matching1 : std_logic;
------------------------------------------------
CONSTANT  res_type_c             : INTEGER := 4;
------------------------------------------------

    ------> PODESAVANJE REZOLUCIJE <------
    --             |                    --
    -- rezolucija  | vrednost parametra --
    --             |    res_type        --
    ---------------|----------------------
    -- 640x480     |      0             --
    -- 800x600     |      1             --
    -- 1024x768    |      2             --
    -- 1152x864    |      3             --
    -- 1280x1024   |      4             --
    --------------------------------------

SIGNAL  pix_clk_s              : STD_LOGIC;
signal  vga_rst_n_s             : STD_LOGIC;
SIGNAL  red_out_s              : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL  green_out_s            : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL  blue_out_s             : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL  red_out_s1              : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL  green_out_s1            : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL  blue_out_s1             : STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL  red_s                  : STD_LOGIC;
SIGNAL  green_s                : STD_LOGIC;
SIGNAL  blue_s                 : STD_LOGIC;
SIGNAL  pixel_row_s            : STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL  pixel_column_s         : STD_LOGIC_VECTOR(10 DOWNTO 0);
-- signali za rom
SIGNAL  char_addr_s            : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL  font_col_s             : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL  font_row_s             : STD_LOGIC_VECTOR( 2 DOWNTO 0);
SIGNAL  rom_out_s              : STD_LOGIC;

-- boje
SIGNAL vsync_d1_r          : STD_LOGIC;
SIGNAL vsync_d2_r          : STD_LOGIC;
SIGNAL vsync_s           : STD_LOGIC;
SIGNAL hsync_s           : STD_LOGIC;
SIGNAL vsync_fe_s        : STD_LOGIC;
-- realizacija modula
BEGIN



  vga_i:vga GENERIC MAP(
                         resolution_type => res_type_c
                       )
              PORT MAP (
                         clk_i           => FPGA_CLK        ,
                         rst_n_i         => FPGA_RESET      ,
                         red_i           => rom_out_s       ,
                         green_i         => rom_out_s       ,
                         blue_i          => rom_out_s       ,
                         red_o           => red_s           ,
                         green_o         => green_s         ,
                         blue_o          => blue_s          ,
                         pixel_row_o     => pixel_row_s     ,
                         pixel_column_o  => pixel_column_s  ,
                         hsync_o         => hsync_s       ,
                         vsync_o         => vsync_s       ,
                         psave_o         => PSAVE           ,
                         blank_o         => BLANK           ,
                         vga_pix_clk_o   => pix_clk_s       ,
                         vga_rst_n_o     => vga_rst_n_s            ,
                         sync_o          => SYNC
                       );



  char_rom_i:char_rom PORT MAP(
                               clk_i                => pix_clk_s    ,        --
                               character_address_i 	=> char_addr_s  ,        -- adresa karaktera
                               font_row_i           => font_row_s   ,        --
                               font_col_i           => font_col_s   ,        --
                               rom_mux_output_o	    => rom_out_s             -- izlazni signal iz char_rom-a
                              );




  -- odredjivanje boje ispisa okvira i pozadine

  rgb_out:PROCESS (
                   pixel_column_s,
                   pixel_row_s   ,
                   red_s         ,
                   green_s       ,
                   blue_s        ,
                   horizontal_res,
                   vertical_res
                  )
  BEGIN
    IF (pixel_row_s    < (hor_cmd1 + 250)                    AND
        pixel_row_s    >= (hor_cmd1)   AND
        pixel_column_s < (ver_cmd1 + 250)                  AND
        pixel_column_s >= (ver_cmd1)      ) THEN
			
			
	ELSE
	 
	 END IF;		
		  
       IF (red_s = '1')   THEN red_out_s <= "00000000"; --((not red_s) & "0000000");
       ELSE                    red_out_s <= "00000000"; --(red_s & "0000000");
       END IF;

       IF (green_s = '1') THEN green_out_s <= "11111111"; --(green_s & "1111111");
       ELSE                    green_out_s <= "00000000";--(green_s & "0000000");
       END IF;

       IF (blue_s = '1')  THEN blue_out_s <= "11111111"; --((not blue_s) & "0100011");
       ELSE                    blue_out_s <= "00000000"; --(blue_s & "0000000");
       END IF;
  END PROCESS rgb_out;


  rgb_out1:PROCESS (						-- PROCES ZA ISPIS PRAVOGUAONIKA
                   pixel_column_s,
                   pixel_row_s,
						 ver_cmd1,
						 hor_cmd1
                  )
  BEGIN
    IF (pixel_row_s    < (ver_cmd1 + 250)                    AND
        pixel_row_s    >= (ver_cmd1)   AND
        pixel_column_s < (hor_cmd1 + 250)                  AND
        pixel_column_s >= (hor_cmd1)      ) THEN

       red_out_s1   <= "11100001";
       green_out_s1 <= "11001111";
       blue_out_s1  <= "11010111";
		 
		 
	 ELSE
       red_out_s1   <= "00000000";
       green_out_s1 <= "00000000";
       blue_out_s1  <= "00000000";

    END IF;
  END PROCESS rgb_out1;

  crashdetect:PROCESS (   					-- PROCES ZA DETEKCIJU SUDARA
                   pixel_column_s,
                   pixel_row_s   ,
                   ver_cmd1         ,
                   ver_cmd       ,
                   hor_cmd1        ,
                   hor_cmd
                  )
  BEGIN
    IF (pixel_row_s    < (ver_cmd1 + 250) AND pixel_row_s    >= (ver_cmd1)   AND ver_cmd < (ver_cmd1 + 250)  AND ver_cmd >= (ver_cmd1) AND
        pixel_column_s < (hor_cmd1 + 250) AND pixel_column_s >= (hor_cmd1) AND  hor_cmd >= hor_cmd1 AND hor_cmd < hor_cmd1 + 250) 
		  
		  THEN

       crash <= '1';
		 
	 ELSE
		 crash <= '0';
    END IF;
  END PROCESS crashdetect;
  
g1:IF res_type_c = 0 GENERATE

    horizontal_res  <= "01010000000"; --640
    vertical_res    <= "00111100000"; --480;

     -- OVDE DODATI KOD

  END GENERATE g1;


----------------------------------------------------------------------------------------
--        rezolucija 800x600
----------------------------------------------------------------------------------------
g2:IF res_type_c = 1 GENERATE

    horizontal_res  <= "01100100000"; --800
    vertical_res    <= "01001011000"; --600

     -- OVDE DODATI KOD

  END GENERATE g2;

----------------------------------------------------------------------------------------
--        rezolucija 1024x768
----------------------------------------------------------------------------------------
g3:IF res_type_c = 2 GENERATE

    horizontal_res  <= "10000000000"; --1024
    vertical_res    <= "01100000000"; --768

      -- OVDE DODATI KOD

  END GENERATE g3;


----------------------------------------------------------------------------------------
--        rezolucija 1152x864
----------------------------------------------------------------------------------------
g4:IF res_type_c = 3 GENERATE

    horizontal_res  <= "10010000000"; --1152
    vertical_res    <= "01101100000"; --864

     -- OVDE DODATI KOD

  END GENERATE g4;


----------------------------------------------------------------------------------------
--        rezolucija 1280x1024
----------------------------------------------------------------------------------------
g5:IF res_type_c = 4 GENERATE
	

    horizontal_res  <= "10100000000"; --1280
    vertical_res    <= "10000000000"; --1024

    addr_gen: PROCESS (pixel_column_s,pixel_row_s)
    BEGIN
      IF (pixel_row_s < ver_cmd AND pixel_row_s >= (ver_cmd - 8)) THEN

        IF    (pixel_column_s < hor_cmd  AND pixel_column_s >= (hor_cmd - 8)) THEN char_addr_s <= o"61";
        ELSIF (pixel_column_s < (hor_cmd + 8)  AND pixel_column_s >= hor_cmd) THEN char_addr_s <= o"62";
        ELSIF (pixel_column_s < (hor_cmd + 16)  AND pixel_column_s >= (hor_cmd + 8)) THEN char_addr_s <= o"70";
        ELSIF (pixel_column_s < (hor_cmd + 24)  AND pixel_column_s >= (hor_cmd + 16)) THEN char_addr_s <= o"60";
        ELSIF (pixel_column_s < (hor_cmd + 32)  AND pixel_column_s >= (hor_cmd + 24)) THEN char_addr_s <= o"30";
        ELSIF (pixel_column_s < (hor_cmd + 40)  AND pixel_column_s >= (hor_cmd + 32)) THEN char_addr_s <= o"61";
        ELSIF (pixel_column_s < (hor_cmd + 48)  AND pixel_column_s >=  (hor_cmd + 40)) THEN char_addr_s <= o"60";
        ELSIF (pixel_column_s < (hor_cmd + 56)  AND pixel_column_s >= (hor_cmd + 48)) THEN char_addr_s <= o"62";
        ELSIF (pixel_column_s < (hor_cmd + 64)  AND pixel_column_s >= (hor_cmd + 56)) THEN char_addr_s <= o"64";
        ELSE                                                           char_addr_s <= o"40";
        END IF;

      ELSE
        char_addr_s <= o"40";
      END IF;
    END PROCESS addr_gen;

  END GENERATE g5;
  -- detektovanje opadajuce ivice vsync signala

  vsync_fe:PROCESS (pix_clk_s)
  BEGIN

    IF ( pix_clk_s'EVENT AND pix_clk_s = '1') THEN

      IF( vga_rst_n_s = '0' ) THEN   vsync_d1_r <= '0';
                                     vsync_d2_r <= '0';

      ELSE                           vsync_d1_r <= vsync_s;
                                     vsync_d2_r <= vsync_d1_r;
      END IF;

    END IF;

  END PROCESS vsync_fe;

  vsync_fe_s <= vsync_d2_r AND NOT vsync_d1_r;
kbd_vga:PROCESS (pix_clk_s)
  BEGIN

    IF( pix_clk_s'EVENT AND pix_clk_s = '1' ) THEN
--
      IF( vga_rst_n_s = '0' ) THEN

         hor_cmd <= "01000000000";
			ver_cmd <= "01010000000";

      ELSE

        IF ( vsync_fe_s = '1') THEN -- enable


          IF ( iHcmd = '0' ) THEN -- pritisnut je taster H
					
					hor_cmd <= hor_cmd + 8;

          ELSIF ( iVcmd = '0' ) THEN -- pritisnut je taster V
			 
				ver_cmd <= ver_cmd - 8;
          END IF;
--
        END IF;
--
      END IF;

    END IF;

  END PROCESS kbd_vga;
----------------------------------------------------------------------------------------

kbd_vga1:PROCESS (pix_clk_s)				-- PROCES ZA POMERANJE PRAVOUGAONIKA
  BEGIN

    IF( pix_clk_s'EVENT AND pix_clk_s = '1' ) THEN
--
      IF( vga_rst_n_s = '0' ) THEN

         
         hor_cmd1 <= "01000100110";
		 ver_cmd1 <= "00101011110";

      ELSE

        IF ( vsync_fe_s = '1') THEN -- enable


          IF ( iHcmd1 = '0' ) THEN -- pritisnut je taster H
					
					hor_cmd1 <= hor_cmd1 + 10;

          ELSIF ( iVcmd1 = '0' ) THEN -- pritisnut je taster V
--
				ver_cmd1 <= ver_cmd1 + 10;
				
          END IF;
--
        END IF;
--
      END IF;

    END IF;

  END PROCESS kbd_vga1;
----------------------------------------------------------------------------


    -- odredjivanje velicine fonta

  font_row_s <= pixel_row_s(2 DOWNTO 0);
  font_col_s <= pixel_column_s(2 DOWNTO 0);

-- povezivanje na izlaz

  RED0    <= red_out_s(0) or red_out_s1(0);   -- R0
  RED1    <= red_out_s(1) or red_out_s1(1);   -- R1
  RED2    <= red_out_s(2) or red_out_s1(2);   -- R2
  RED3    <= red_out_s(3) or red_out_s1(3);   -- R3
  RED4    <= red_out_s(4) or red_out_s1(4);   -- R4
  RED5    <= red_out_s(5) or red_out_s1(5);   -- R5
  RED6    <= red_out_s(6) or red_out_s1(6);   -- R6
  RED7    <= red_out_s(7) or red_out_s1(7);   -- R7

  GREEN0  <= green_out_s(0) or green_out_s1(0); -- G0
  GREEN1  <= green_out_s(1) or green_out_s1(1); -- G1
  GREEN2  <= green_out_s(2) or green_out_s1(2); -- G2
  GREEN3  <= green_out_s(3) or green_out_s1(3); -- G3
  GREEN4  <= green_out_s(4) or green_out_s1(4); -- G4
  GREEN5  <= green_out_s(5) or green_out_s1(5); -- G5
  GREEN6  <= green_out_s(6) or green_out_s1(6); -- G6
  GREEN7  <= green_out_s(7) or green_out_s1(7); -- G7

  BLUE0   <= blue_out_s(0) or blue_out_s1(0);  -- B0
  BLUE1   <= blue_out_s(1) or blue_out_s1(1);  -- B1
  BLUE2   <= blue_out_s(2) or blue_out_s1(2);  -- B2
  BLUE3   <= blue_out_s(3) or blue_out_s1(3);  -- B3
  BLUE4   <= blue_out_s(4) or blue_out_s1(4);  -- B4
  BLUE5   <= blue_out_s(5) or blue_out_s1(5);  -- B5
  BLUE6   <= blue_out_s(6) or blue_out_s1(6);  -- B6
  BLUE7   <= blue_out_s(7) or blue_out_s1(7);  -- B7
  
  
  PIX_CLOCK <= pix_clk_s;
  VGA_HSYNC <= hsync_s;
  VGA_VSYNC <= vsync_s;
END rtl;



























