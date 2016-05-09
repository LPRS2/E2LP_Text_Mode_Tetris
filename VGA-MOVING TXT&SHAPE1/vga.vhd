----------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije                  --
--  Copyright © 2009 All Rights Reserved                                        --
----------------------------------------------------------------------------------
--                                                                              --
-- Autor: LPRS2 TIM 2009/2010 <LPRS2@KRT.neobee.net>                            --
--                                                                              --
-- Datum izrade: /                                                              --
-- Naziv Modula: vga.vhd                                                        --
-- Naziv projekta:                                                              --
--                                                                              --
-- Opis:  /                                                                     --
--                                                                              --
-- Ukljucuje module: vga_sync,dcm25MHz,dcm50MHz,dcm75MHz,dcm108MHz              --
--                                                                              --
-- Verzija : 1.0                                                                --
--                                                                              --
-- Dodatni komentari: /                                                         --
--                                                                              --
-- ULAZI: clk_i                                                                 --
--        rst_n_i                                                               --
--        red_i                                                                 --
--        green_i                                                               --
--        blue_i                                                                --
-- IZLAZI: red_o                                                                --
--         green_o                                                              --
--         blue_o                                                               --
--         pixel_row_o                                                          --
--         pixel_column_o                                                       --
--         hsync_o                                                              --
--         vsync_o                                                              --
--         psave_o                                                              --
--         blank_o                                                              --
--         vga_pix_clk_o                                                        --
--         vga_rst_o                                                            --
--         sync_o                                                               --
--                                                                              --
-- PARAMETRI : resolution_type                                                  --
--                                                                              --
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga IS GENERIC (
                       -- podrzane rezolucije vga ekrana -- vrednost parametra
                       --     rezolucija 640x480         --        0
                       --     rezolucija 800x600         --        1
                       --     rezolucija 1024x768        --        2
                       --     rezolucija 1152x864        --        3
                       --     rezolucija 1280x1024       --        4
                       resolution_type : integer  := 0
                      );
              PORT(
                   clk_i          : IN  STD_LOGIC;                       -- takt
                   rst_n_i        : IN  STD_LOGIC;                       -- reset
                   red_i          : IN  STD_LOGIC;                       -- ulazna  vrednost crvene boje
                   green_i        : IN  STD_LOGIC;                       -- ulazna  vrednost zelene boje
                   blue_i         : IN  STD_LOGIC;                       -- ulazna  vrednost plave  boje
                   red_o          : OUT STD_LOGIC;                       -- izlazna vrednost crvene boje
                   green_o        : OUT STD_LOGIC;                       -- izlazna vrednost zelene boje
                   blue_o         : OUT STD_LOGIC;                       -- izlazna vrednost plave  boje
                   pixel_row_o    : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);   -- pozicija pixela po vrstama
                   pixel_column_o : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);   -- pozicija pixela po kolonama
                   hsync_o        : OUT STD_LOGIC;                       -- horizontalna sinhronizacija
                   vsync_o        : OUT STD_LOGIC;                       -- vertikalna   sinhronizacija
                   psave_o        : OUT STD_LOGIC;                       -- signal kontrole napajanja, MORA uvek na visokom logickom nivou
                   blank_o        : OUT STD_LOGIC;                       -- aktivni deo linije
                   vga_pix_clk_o  : OUT STD_LOGIC;                       -- takt sa kojim je sinhronizovano ispisivanje pixela
                   vga_rst_n_o    : OUT STD_LOGIC;                       -- reset sinhronizovan sa vga_pix_clk_o taktom
                   sync_o         : OUT STD_LOGIC                        -- sjedinjena vertikalna i horizontalna sinhronizacija
                  );
END vga;

ARCHITECTURE rtl OF vga IS
-- instanciranje komponente
COMPONENT vga_sync IS GENERIC (
                            horizontal_res : integer :=  800;
                            vertical_res   : integer :=  600
                           );
                     PORT (
                            clk_i          : IN   STD_LOGIC;
                            rst_n_i        : IN   STD_LOGIC;
                            red_i          : IN   STD_LOGIC;
                            green_i        : IN   STD_LOGIC;
                            blue_i         : IN   STD_LOGIC;
                            red_o          : OUT  STD_LOGIC;
                            green_o        : OUT  STD_LOGIC;
                            blue_o         : OUT  STD_LOGIC;
                            horiz_sync_o   : OUT  STD_LOGIC;
                            vert_sync_o    : OUT  STD_LOGIC;
                            pixel_row_o    : OUT  STD_LOGIC_VECTOR (10 DOWNTO 0);
                            pixel_column_o : OUT  STD_LOGIC_VECTOR (10 DOWNTO 0);
                            psave_o        : OUT  STD_LOGIC;
                            blank_o        : OUT  STD_LOGIC;
                            pix_clk_o      : OUT  STD_LOGIC;
                            sync_o         : OUT  STD_LOGIC
                           );
END COMPONENT vga_sync;

COMPONENT dcm25MHz IS 
	port
	 (-- Clock in ports
	  CLK_IN1           : in     std_logic;
	  -- Clock out ports
	  CLK_OUT1          : out    std_logic;
	  -- Status and control signals
	  RESET             : in     std_logic;
	  LOCKED            : out    std_logic
	 );
END COMPONENT dcm25MHz;
COMPONENT dcm50MHz IS 
	port
	 (-- Clock in ports
	  CLK_IN1           : in     std_logic;
	  -- Clock out ports
	  CLK_OUT1          : out    std_logic;
	  -- Status and control signals
	  RESET             : in     std_logic;
	  LOCKED            : out    std_logic
	 );
END COMPONENT dcm50MHz;
COMPONENT dcm75MHz IS 
	port
	 (-- Clock in ports
	  CLK_IN1           : in     std_logic;
	  -- Clock out ports
	  CLK_OUT1          : out    std_logic;
	  -- Status and control signals
	  RESET             : in     std_logic;
	  LOCKED            : out    std_logic
	 );
END COMPONENT dcm75MHz;
COMPONENT dcm108MHz IS 
	port
	 (-- Clock in ports
	  CLK_IN1           : in     std_logic;
	  -- Clock out ports
	  CLK_OUT1          : out    std_logic;
	  -- Status and control signals
	  RESET             : in     std_logic;
	  LOCKED            : out    std_logic
	 );
END COMPONENT dcm108MHz;
COMPONENT SRL16 PORT (
                      A0  : IN  STD_LOGIC;
                      A1  : IN  STD_LOGIC;
                      A2  : IN  STD_LOGIC;
                      A3  : IN  STD_LOGIC;
                      CLK : IN  STD_LOGIC;
                      D   : IN  STD_LOGIC;
                      Q   : OUT STD_LOGIC
                     );
END COMPONENT SRL16;

-- signali
SIGNAL  rst_s               : STD_LOGIC;   -- invertovani ulazni reset, povezuje se na DCM, sluzi za resetovanje DCM-a
SIGNAL  clk_s               : STD_LOGIC;   -- izlazni takt iz DCM-a
SIGNAL  locked_s            : STD_LOGIC;   -- signal locked iz DCM-a
SIGNAL  locked_del_s        : STD_LOGIC;   -- zakasnjeni signal locked iz DCM-a
SIGNAL  locked_del_reg_r    : STD_LOGIC;   -- registrovan zakasnjeni signal locked iz DCM-a



BEGIN

rst_s <= NOT rst_n_i;

-- u zavisnosti od prametra resolution_type se vrsi instanciranje komponenti (DCM,SRL16)
----------------------------------------------------------------------------------------
--        rezolucija 640x480
----------------------------------------------------------------------------------------
res_0: IF ( resolution_type = 0 ) GENERATE

          
          dcm25_i:dcm25MHz PORT MAP(
                                    CLK_IN1        => clk_i        ,
                                    RESET          => rst_s        ,
                                    CLK_OUT1       => clk_s        ,
                                    LOCKED     => locked_s
                                   );

          SRL16_inst:SRL16 PORT MAP(
                                    CLK  => clk_s         ,      -- Clock     input
                                    D    => locked_s      ,      -- SRL data  input
                                    A0   => '1'           ,      -- Select[0] input
                                    A1   => '1'           ,      -- Select[1] input
                                    A2   => '1'           ,      -- Select[2] input
                                    A3   => '1'           ,      -- Select[3] input
                                    Q    => locked_del_s         -- SRL data  output
                                   );

          PROCESS (clk_s)
          BEGIN
            IF (clk_s'EVENT AND clk_s='1') THEN
              IF ( rst_n_i = '0' )  THEN  locked_del_reg_r <='0';
              ELSE                        locked_del_reg_r <= locked_del_s;
              END IF;
            END IF;
          END PROCESS;

          vga_rst_n_o <= locked_del_reg_r;


          -- povezivanje sa vga_sync modulom
          vga_sync_i:vga_sync GENERIC MAP(
                                        horizontal_res => 640,
                                        vertical_res   => 480
                                       )
                            PORT MAP(
                                    clk_i           => clk_s            ,
                                    rst_n_i         => locked_del_reg_r ,
                                    red_i           => red_i            ,
                                    green_i         => green_i          ,
                                    blue_i          => blue_i           ,
                                    red_o           => red_o            ,
                                    green_o         => green_o          ,
                                    blue_o          => blue_o           ,
                                    horiz_sync_o    => hsync_o          ,
                                    vert_sync_o     => vsync_o          ,
                                    pixel_row_o     => pixel_row_o      ,
                                    pixel_column_o  => pixel_column_o   ,
                                    psave_o         => psave_o          ,
                                    blank_o         => blank_o          ,
                                    pix_clk_o       => vga_pix_clk_o    ,
                                    sync_o          => sync_o
                                    );

       END GENERATE res_0;

----------------------------------------------------------------------------------------
--        rezolucija 800x600
----------------------------------------------------------------------------------------
res_1: IF ( resolution_type = 1 ) GENERATE

          dcm50_i:dcm50MHz PORT MAP(
                                    CLK_IN1        => clk_i        ,
                                    RESET          => rst_s        ,
                                    CLK_OUT1       => clk_s        ,
                                    LOCKED     => locked_s
                                   );

          SRL16_inst:SRL16 PORT MAP(
                                    CLK  => clk_s         ,      -- Clock     input
                                    D    => locked_s      ,      -- SRL data  input
                                    A0   => '1'           ,      -- Select[0] input
                                    A1   => '1'           ,      -- Select[1] input
                                    A2   => '1'           ,      -- Select[2] input
                                    A3   => '1'           ,      -- Select[3] input
                                    Q    => locked_del_s         -- SRL data  output
                                   );

          PROCESS (clk_s)
          BEGIN
            IF (clk_s'EVENT AND clk_s='1') THEN
              IF ( rst_n_i = '0' )  THEN  locked_del_reg_r <='0';
              ELSE                        locked_del_reg_r <= locked_del_s;
              END IF;
            END IF;
          END PROCESS;

          vga_rst_n_o <= locked_del_reg_r;


          -- povezivanje sa vga_sync modulom
          vga_sync_i:vga_sync GENERIC MAP(
                                        horizontal_res => 800,
                                        vertical_res   => 600
                                       )
                              PORT MAP(
                                       clk_i           => clk_s            ,
                                       rst_n_i         => locked_del_reg_r ,
                                       red_i           => red_i            ,
                                       green_i         => green_i          ,
                                       blue_i          => blue_i           ,
                                       red_o           => red_o            ,
                                       green_o         => green_o          ,
                                       blue_o          => blue_o           ,
                                       horiz_sync_o    => hsync_o          ,
                                       vert_sync_o     => vsync_o          ,
                                       pixel_row_o     => pixel_row_o      ,
                                       pixel_column_o  => pixel_column_o   ,
                                       psave_o         => psave_o          ,
                                       blank_o         => blank_o          ,
                                       pix_clk_o       => vga_pix_clk_o    ,
                                       sync_o          => sync_o
                                      );

       END GENERATE res_1;

----------------------------------------------------------------------------------------
--        rezolucija 1024x768
----------------------------------------------------------------------------------------
res_2: IF ( resolution_type = 2 ) GENERATE

          dcm75_i:dcm75MHz PORT MAP(
                                    CLK_IN1        => clk_i        ,
                                    RESET          => rst_s        ,
                                    CLK_OUT1       => clk_s        ,
                                    LOCKED     => locked_s
                                   );


          SRL16_inst:SRL16 PORT MAP(
                                    CLK  => clk_s         ,      -- Clock     input
                                    D    => locked_s      ,      -- SRL data  input
                                    A0   => '1'           ,      -- Select[0] input
                                    A1   => '1'           ,      -- Select[1] input
                                    A2   => '1'           ,      -- Select[2] input
                                    A3   => '1'           ,      -- Select[3] input
                                    Q    => locked_del_s         -- SRL data  output
                                   );

          PROCESS (clk_s)
          BEGIN
            IF (clk_s'EVENT AND clk_s='1') THEN
              IF ( rst_n_i = '0' )  THEN  locked_del_reg_r <='0';
              ELSE                        locked_del_reg_r <= locked_del_s;
              END IF;
            END IF;
          END PROCESS;

          vga_rst_n_o <= locked_del_reg_r;


           -- povezivanje sa vga_sync modulom
          vga_sync_i:vga_sync GENERIC MAP(
                                        horizontal_res => 1024,
                                        vertical_res   => 768
                                       )
                              PORT MAP(
                                       clk_i           => clk_s            ,
                                       rst_n_i         => locked_del_reg_r ,
                                       red_i           => red_i            ,
                                       green_i         => green_i          ,
                                       blue_i          => blue_i           ,
                                       red_o           => red_o            ,
                                       green_o         => green_o          ,
                                       blue_o          => blue_o           ,
                                       horiz_sync_o    => hsync_o          ,
                                       vert_sync_o     => vsync_o          ,
                                       pixel_row_o     => pixel_row_o      ,
                                       pixel_column_o  => pixel_column_o   ,
                                       psave_o         => psave_o          ,
                                       blank_o         => blank_o          ,
                                       pix_clk_o       => vga_pix_clk_o    ,
                                       sync_o          => sync_o
                                      );

       END GENERATE res_2;

----------------------------------------------------------------------------------------
--        rezolucija 1152x864
----------------------------------------------------------------------------------------
res_3: IF ( resolution_type = 3 ) GENERATE

          
          dcm108_i:dcm108MHz PORT MAP(
                                    CLK_IN1        => clk_i        ,
                                    RESET          => rst_s        ,
                                    CLK_OUT1       => clk_s        ,
                                    LOCKED     => locked_s
                                   );


          SRL16_inst:SRL16 PORT MAP(
                                    CLK  => clk_s         ,      -- Clock     input
                                    D    => locked_s      ,      -- SRL data  input
                                    A0   => '1'           ,      -- Select[0] input
                                    A1   => '1'           ,      -- Select[1] input
                                    A2   => '1'           ,      -- Select[2] input
                                    A3   => '1'           ,      -- Select[3] input
                                    Q    => locked_del_s         -- SRL data  output
                                   );

          PROCESS (clk_s)
          BEGIN
            IF (clk_s'EVENT AND clk_s='1') THEN
              IF ( rst_n_i = '0' )  THEN  locked_del_reg_r <='0';
              ELSE                        locked_del_reg_r <= locked_del_s;
              END IF;
            END IF;
          END PROCESS;

          vga_rst_n_o <= locked_del_reg_r;


          -- povezivanje sa vga_sync modulom
          vga_sync_i:vga_sync GENERIC MAP(
                                        horizontal_res => 1152,
                                        vertical_res   => 864
                                       )
                              PORT MAP(
                                       clk_i           => clk_s            ,
                                       rst_n_i         => locked_del_reg_r ,
                                       red_i           => red_i            ,
                                       green_i         => green_i          ,
                                       blue_i          => blue_i           ,
                                       red_o           => red_o            ,
                                       green_o         => green_o          ,
                                       blue_o          => blue_o           ,
                                       horiz_sync_o    => hsync_o          ,
                                       vert_sync_o     => vsync_o          ,
                                       pixel_row_o     => pixel_row_o      ,
                                       pixel_column_o  => pixel_column_o   ,
                                       psave_o         => psave_o          ,
                                       blank_o         => blank_o          ,
                                       pix_clk_o       => vga_pix_clk_o    ,
                                       sync_o          => sync_o
                                      );
       END GENERATE res_3;

----------------------------------------------------------------------------------------
--        rezolucija 1280x1024
----------------------------------------------------------------------------------------
res_4: IF ( resolution_type = 4 ) GENERATE

          dcm108_i:dcm108MHz PORT MAP(
                                    CLK_IN1        => clk_i        ,
                                    RESET          => rst_s        ,
                                    CLK_OUT1       => clk_s        ,
                                    LOCKED     => locked_s
                                   );

          SRL16_inst:SRL16 PORT MAP(
                                    CLK  => clk_s         ,      -- Clock     input
                                    D    => locked_s      ,      -- SRL data  input
                                    A0   => '1'           ,      -- Select[0] input
                                    A1   => '1'           ,      -- Select[1] input
                                    A2   => '1'           ,      -- Select[2] input
                                    A3   => '1'           ,      -- Select[3] input
                                    Q    => locked_del_s         -- SRL data  output
                                   );

          PROCESS (clk_s)
          BEGIN
            IF (clk_s'EVENT AND clk_s='1') THEN
              IF ( rst_n_i = '0' )  THEN  locked_del_reg_r <='0';
              ELSE                        locked_del_reg_r <= locked_del_s;
              END IF;
            END IF;
          END PROCESS;

          vga_rst_n_o <= locked_del_reg_r;

         -- povezivanje sa vga_sync modulom
        vga_sync_i:vga_sync GENERIC MAP(
                                        horizontal_res => 1280,
                                        vertical_res   => 1024
                                       )
                              PORT MAP(
                                       clk_i           => clk_s            ,
                                       rst_n_i         => locked_del_reg_r ,
                                       red_i           => red_i            ,
                                       green_i         => green_i          ,
                                       blue_i          => blue_i           ,
                                       red_o           => red_o            ,
                                       green_o         => green_o          ,
                                       blue_o          => blue_o           ,
                                       horiz_sync_o    => hsync_o          ,
                                       vert_sync_o     => vsync_o          ,
                                       pixel_row_o     => pixel_row_o      ,
                                       pixel_column_o  => pixel_column_o   ,
                                       psave_o         => psave_o          ,
                                       blank_o         => blank_o          ,
                                       pix_clk_o       => vga_pix_clk_o    ,
                                       sync_o          => sync_o
                                      );

       END GENERATE res_4;

END rtl;



