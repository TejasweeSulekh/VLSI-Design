library IEEE;
use IEEE.std_logic_1164.all;

entity multiply_accumulate is 
    -- perform ab + c --
    port(
        a, b: in std_logic_vector(15 downto 0);
        c: in std_logic_vector(31 downto 0);
        s: out std_logic_vector(31 downto 0);
        cout: out std_logic
    );
end entity;

architecture behave of multiply_accumulate is
    -- component declarations --
    component andgate is
        port (a, b: in std_logic;
        prod: out std_logic);
    end component;

    component fa is 
        port(
            a,b,cin: in std_logic;
            s,cout: out std_logic
        );
    end component;

    component ha is
        port(
            a,b: in std_logic;
            s, c: out std_logic
        );
    end component;

    component brentkung is
        port(
            a,b: in std_logic_vector(31 downto 0);
            s: out std_logic_vector(31 downto 0);
            cout: out std_logic;
            cin: in std_logic
        );
    end component;

    -- LOW signal for carry in of Brent Kung Adder--
    signal gnd_sig: std_logic := '0';

    -- layer 1 signal declarations--
    -- we make rows corresponding to the first layer--
    signal layer1_r1: std_logic_vector(31 downto 0);
    signal layer1_r2: std_logic_vector(15 downto 0);
    signal layer1_r3: std_logic_vector(16 downto 1);
    signal layer1_r4: std_logic_vector(17 downto 2);
    signal layer1_r5: std_logic_vector(18 downto 3);
    signal layer1_r6: std_logic_vector(19 downto 4);
    signal layer1_r7: std_logic_vector(20 downto 5);
    signal layer1_r8: std_logic_vector(21 downto 6);
    signal layer1_r9: std_logic_vector(22 downto 7);
    signal layer1_r10: std_logic_vector(23 downto 8);
    signal layer1_r11: std_logic_vector(24 downto 9);
    signal layer1_r12: std_logic_vector(25 downto 10);
    signal layer1_r13: std_logic_vector(26 downto 11);
    signal layer1_r14: std_logic_vector(27 downto 12);
    signal layer1_r15: std_logic_vector(28 downto 13);
    signal layer1_r16: std_logic_vector(29 downto 14);
    signal layer1_r17: std_logic_vector(30 downto 15);

    -- signals for connections--
    signal wire: std_logic_vector(423 downto 0);
    
    -- final sum argument signals--
    -- first argument (top row of final layer)--
    signal arg1: std_logic_vector(31 downto 0);
    -- second argument (bottom row of final layer)--
    signal arg2: std_logic_vector(31 downto 0);

begin
    -- set first row as 32 bit sum--
    layer1_r1 <= c;

    -- [a1 a2 a3 ... a16] is the 16x16 array of AND gates--
    -- accordingly set the subsequent signals for other rows-- 
    a1: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(0), prod => layer1_r2(i)); 
    end generate a1;

    a2: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(1), prod => layer1_r3(i + 1)); 
    end generate a2;

    a3: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(2), prod => layer1_r4(i + 2)); 
    end generate a3;

    a4: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(3), prod => layer1_r5(i + 3)); 
    end generate a4;
    
    a5: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(4), prod => layer1_r6(i + 4)); 
    end generate a5;

    a6: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(5), prod => layer1_r7(i + 5)); 
    end generate a6;
    
    a7: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(6), prod => layer1_r8(i + 6)); 
    end generate a7;
    
    a8: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(7), prod => layer1_r9(i + 7)); 
    end generate a8;

    a9: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(8), prod => layer1_r10(i + 8)); 
    end generate a9;

    a10: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(9), prod => layer1_r11(i + 9)); 
    end generate a10;

    a11: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(10), prod => layer1_r12(i + 10)); 
    end generate a11;

    a12: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(11), prod => layer1_r13(i + 11)); 
    end generate a12;

    a13: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(12), prod => layer1_r14(i + 12)); 
    end generate a13;

    a14: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(13), prod => layer1_r15(i + 13)); 
    end generate a14;

    a15: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(14), prod => layer1_r16(i + 14)); 
    end generate a15;

    a16: for i in 0 to 15 generate
        and_i: andgate port map(a => b(i), b => a(15), prod => layer1_r17(i + 15)); 
    end generate a16;


    -- connections are made column wise as per the diagram--

    --column 1--
    arg1(0) <= layer1_r1(0);
    arg2(0) <= layer1_r2(0);
    
    --column 2--
    h1: ha port map(a => layer1_r1(1), b => layer1_r2(1), s => arg1(1), c => arg2(2));
    arg2(1) <= layer1_r3(1);
    
    --column 3--
    h2: ha port map(a => layer1_r1(2), b => layer1_r2(2), s => wire(0), c => wire(1)); 
    f1: fa port map(a => wire(0), b => layer1_r3(2), cin=> layer1_r4(2), s => arg1(2), cout => arg2(3)); 
    
    --column 4--
    h3: ha port map(a => layer1_r1(3), b => layer1_r2(3), s => wire(2), c => wire(3)); 
    f2: fa port map(a => wire(2), b => layer1_r3(3), cin => layer1_r4(3), s => wire(4), cout => wire(5)); 
    f3: fa port map(a => layer1_r5(3), b => wire(1), cin => wire(4), s => arg1(3), cout => arg2(4)); 
    
    --column 5--
    f4: fa port map(a => layer1_r1(4), b => layer1_r2(4), cin => layer1_r3(4), s => wire(6), cout => wire(7)); 
    h4: ha port map(a => layer1_r4(4), b => layer1_r5(4), s => wire(8), c => wire(9)); 
    f5: fa port map(a => wire(6), b => wire(8), cin => wire(3), s => wire(10), cout =>wire(11)); 
    f6: fa port map(a => wire(10), b => wire(5), cin => layer1_r6(4), s => arg1(4), cout =>arg2(5)); 
    
    --column 6--
    h5: ha port map(a => layer1_r1(5), b => layer1_r2(5), s =>wire(12), c =>wire(13)); 
    f7: fa port map(a => wire(12), b => layer1_r3(5), cin => layer1_r4(5), s => wire(14), cout =>wire(15)); 
    f8: fa port map(a => layer1_r5(5), b => layer1_r6(5), cin => layer1_r7(5), s => wire(16), cout =>wire(17)); 
    f9: fa port map(a => wire(14), b => wire(16), cin => wire(7), s => wire(18), cout =>wire(19)); 
    f10: fa port map(a => wire(18), b => wire(9) , cin => wire(11), s => arg1(5), cout => arg2(6)); 
    
    --column 7--
    f11: fa port map(a => layer1_r1(6), b => layer1_r2(6), cin => layer1_r3(6), s => wire(20), cout => wire(83)); 
    h6: ha port map(a => layer1_r4(6), b => layer1_r5(6), s =>wire(21), c =>wire(22)); 
    f12: fa port map(a => wire(20), b => wire(21), cin => wire(13), s => wire(23), cout => wire(24)); 
    f13: fa port map(a => layer1_r6(6), b => layer1_r7(6), cin => layer1_r8(6), s => wire(25), cout => wire(26)); 
    f14: fa port map(a => wire(23), b => wire(25), cin => wire(15), s => wire(27), cout => wire(28)); 
    f15: fa port map(a => wire(27), b => wire(17), cin => wire(19), s => arg1(6), cout => arg2(7)); 

    --column 8--
    f16: fa port map(a => layer1_r1(7), b => layer1_r2(7), cin => layer1_r3(7), s => wire(29), cout => wire(30)); 
    f17: fa port map(a => layer1_r4(7), b => layer1_r5(7), cin => layer1_r6(7), s => wire(31), cout => wire(32)); 
    h7: ha port map(a => layer1_r7(7), b => layer1_r8(7), s => wire(33), c => wire(34)); 
    f18: fa port map(a=>wire(29), b=>wire(31), cin=>wire(83), s=>wire(35), cout=>wire(36)); 
    f19: fa port map(a=>wire(33), b=>layer1_r9(7), cin=>wire(22), s=>wire(37), cout=>wire(38)); 
    f20: fa port map(a=>wire(35), b=>wire(37), cin=>wire(24), s=>wire(39), cout=>wire(40));
    f21: fa port map(a=>wire(39), b=>wire(26), cin=>wire(28), s=>arg1(7), cout=>arg2(8)); 

    --column 9--
    h8: ha port map(a => layer1_r1(8), b => layer1_r2(8), s => wire(41), c => wire(42)); 
    f22: fa port map(a => layer1_r3(8), b => layer1_r4(8), cin => layer1_r5(8), s => wire(43), cout => wire(44)); 
    f23: fa port map(a => layer1_r6(8), b => layer1_r7(8), cin => layer1_r8(8), s => wire(45), cout => wire(46));
    f24: fa port map(a => layer1_r10(8), b => layer1_r9(8), cin => wire(41), s => wire(47), cout => wire(48)); 
    f25: fa port map(a => wire(43), b => wire(45), cin => wire(47), s => wire(49), cout => wire(50));
    f26: fa port map(a => wire(34), b => wire(30), cin => wire(32), s => wire(51), cout => wire(52)); 
    f27: fa port map(a => wire(49), b => wire(36), cin => wire(38), s => wire(53), cout => wire(54));
    f28: fa port map(a => wire(40), b => wire(51), cin => wire(53), s => arg1(8), cout => arg2(9));

    --column 10--
    h9: ha port map(a => layer1_r1(9), b => layer1_r2(9), s => wire(55), c => wire(56)); 
    f29: fa port map(a => layer1_r3(9), b => layer1_r4(9), cin => layer1_r5(9), s => wire(57), cout => wire(58)); 
    f30: fa port map(a => layer1_r6(9), b => layer1_r7(9), cin => layer1_r8(9), s => wire(59), cout => wire(60)); 
    f31: fa port map(a => layer1_r9(9), b => layer1_r10(9), cin => layer1_r11(9), s => wire(61), cout => wire(62)); 
    f32: fa port map(a => wire(55), b => wire(57), cin => wire(42), s => wire(63), cout => wire(64)); 
    f33: fa port map(a => wire(59), b => wire(61), cin => wire(63), s => wire(65), cout => wire(66)); 
    f34: fa port map(a => wire(44), b => wire(46), cin => wire(48), s => wire(67), cout => wire(68)); 
    f35: fa port map(a => wire(65), b => wire(50), cin => wire(52), s => wire(69), cout => wire(70)); 
    f36: fa port map(a => wire(67), b => wire(69), cin => wire(54), s => arg1(9), cout => arg2(10));

    --column 11--
    h10: ha port map(a => layer1_r1(10), b => layer1_r2(10), s => wire(71), c => wire(72)); 
    f37: fa port map(a => layer1_r3(10), b => layer1_r4(10), cin => layer1_r5(10), s => wire(73), cout => wire(74)); 
    f38: fa port map(a => layer1_r6(10), b => layer1_r7(10), cin => layer1_r8(10), s => wire(75), cout => wire(76)); 
    f39: fa port map(a => layer1_r9(10), b => layer1_r10(10), cin => layer1_r11(10), s => wire(77), cout => wire(78)); 
    f40: fa port map(a => layer1_r12(10), b => wire(71), cin => wire(73), s => wire(79), cout => wire(80));
    f41: fa port map(a => wire(75), b => wire(56), cin => wire(58), s => wire(81), cout => wire(82)); 
    f42: fa port map(a => wire(77), b => wire(79), cin => wire(81), s => wire(84), cout => wire(85));
    f43: fa port map(a => wire(60), b => wire(62), cin => wire(64), s => wire(86), cout => wire(87)); 
    f44: fa port map(a => wire(84), b => wire(66), cin => wire(68), s => wire(88), cout => wire(89)); 
    f45: fa port map(a => wire(88), b => wire(70), cin => wire(86), s => arg1(10), cout => arg2(11));

    --column 12--
    h12: ha port map(a => layer1_r1(11), b => layer1_r2(11), s => wire(90), c => wire(91)); 
    f46: fa port map(a => layer1_r3(11), b => layer1_r4(11), cin => layer1_r5(11), s => wire(92), cout => wire(93)); 
    f47: fa port map(a => layer1_r6(11), b => layer1_r7(11), cin => layer1_r8(11), s => wire(94), cout => wire(95)); 
    f48: fa port map(a => layer1_r9(11), b => layer1_r10(11), cin => layer1_r11(11), s => wire(96), cout => wire(97)); 
    f49: fa port map(a => layer1_r12(11), b => layer1_r13(11), cin => wire(90), s => wire(98), cout => wire(99)); 
    f50: fa port map(a => wire(92), b => wire(94), cin => wire(96), s => wire(100), cout => wire(101)); 
    f51: fa port map(a => wire(72), b => wire(74), cin => wire(76), s => wire(102), cout => wire(103)); 
    f52: fa port map(a => wire(98), b => wire(100), cin => wire(102), s => wire(104), cout => wire(105)); 
    f53: fa port map(a => wire(78), b => wire(80), cin => wire(82), s => wire(106), cout => wire(107)); 
    f54: fa port map(a => wire(104), b => wire(85), cin => wire(87), s => wire(108), cout => wire(109));
    f55: fa port map(a => wire(106), b => wire(108), cin => wire(89), s => arg1(11), cout => arg2(12));

    --column 13--
    h13: ha port map(a => layer1_r1(12), b => layer1_r2(12), s => wire(110), c => wire(111));
    f56: fa port map(a => layer1_r3(12), b => layer1_r4(12), cin => layer1_r5(12), s => wire(112), cout => wire(113));
    f57: fa port map(a => layer1_r6(12), b => layer1_r7(12), cin => layer1_r8(12), s => wire(114), cout => wire(115));
    f58: fa port map(a => layer1_r9(12), b => layer1_r10(12), cin => layer1_r11(12), s => wire(116), cout => wire(117));
    f59: fa port map(a => layer1_r12(12), b => layer1_r13(12), cin => layer1_r14(12), s => wire(118), cout => wire(119)); 
    f60: fa port map(a => wire(110), b => wire(112), cin => wire(114), s => wire(120), cout => wire(121)); 
    f61: fa port map(a => wire(116), b => wire(118), cin => wire(91), s => wire(122), cout => wire(123));
    f62: fa port map(a => wire(93), b => wire(95), cin => wire(97), s => wire(124), cout => wire(125)); 
    f63: fa port map(a => wire(120), b => wire(122), cin => wire(124), s => wire(126), cout => wire(127)); 
    f64: fa port map(a => wire(99), b => wire(101), cin => wire(103), s => wire(128), cout => wire(129)); 
    f65: fa port map(a => wire(126), b => wire(105), cin => wire(107), s => wire(130), cout => wire(131));
    f66: fa port map(a => wire(128), b => wire(130), cin => wire(109), s => arg1(12), cout => arg2(13));

    --column 14--
    h14: ha port map(a => layer1_r1(13), b => layer1_r2(13), s => wire(132), c => wire(133)); 
    f67: fa port map(a => layer1_r3(13), b => layer1_r4(13), cin => layer1_r5(13), s => wire(134), cout => wire(135)); 
    f68: fa port map(a => layer1_r6(13), b => layer1_r7(13), cin => layer1_r8(13), s => wire(136), cout => wire(137));
    f69: fa port map(a => layer1_r9(13), b => layer1_r10(13), cin => layer1_r11(13), s => wire(138), cout => wire(139)); 
    f70: fa port map(a => layer1_r12(13), b => layer1_r13(13), cin => layer1_r14(13), s => wire(140), cout => wire(141)); 
    f71: fa port map(a => layer1_r15(13), b => wire(132), cin => wire(111), s => wire(142), cout => wire(143)); 
    f72: fa port map(a => wire(134), b => wire(136), cin => wire(138), s => wire(144), cout => wire(145)); 
    f73: fa port map(a => wire(140), b => wire(142), cin => wire(113), s => wire(146), cout => wire(147)); 
    f74: fa port map(a => wire(115), b => wire(117), cin => wire(119), s => wire(148), cout => wire(149)); 
    f75: fa port map(a => wire(144), b => wire(146), cin => wire(148), s => wire(150), cout => wire(151)); 
    f76: fa port map(a => wire(121), b => wire(123), cin => wire(125), s => wire(152), cout => wire(153)); 
    f77: fa port map(a => wire(150), b => wire(127), cin => wire(129), s => wire(154), cout => wire(155));
    f78: fa port map(a => wire(152), b => wire(131), cin => wire(154), s => arg1(13), cout => arg2(14));

    --column 15--
    h15: ha port map(a => layer1_r1(14), b => layer1_r2(14), s => wire(156), c => wire(157)); 
    f79: fa port map(a => layer1_r3(14), b => layer1_r4(14), cin => layer1_r5(14), s => wire(159), cout => wire(160)); 
    f80: fa port map(a => layer1_r6(14), b => layer1_r7(14), cin => layer1_r8(14), s => wire(161), cout => wire(162)); 
    f81: fa port map(a => layer1_r9(14), b => layer1_r10(14), cin => layer1_r11(14), s => wire(163), cout => wire(164));
    f82: fa port map(a => layer1_r12(14), b => layer1_r13(14), cin => layer1_r14(14), s => wire(165), cout => wire(166));
    f83: fa port map(a => layer1_r15(14), b => layer1_r16(14), cin => wire(156), s => wire(167), cout => wire(168));
    f84: fa port map(a => wire(133), b => wire(135), cin => wire(159), s => wire(169), cout => wire(170));
    f85: fa port map(a => wire(161), b => wire(163), cin => wire(165), s => wire(171), cout => wire(172)); 
    f86: fa port map(a => wire(167), b => wire(169), cin => wire(137), s => wire(173), cout => wire(174));
    f87: fa port map(a => wire(139), b => wire(141), cin => wire(143), s => wire(175), cout => wire(176));
    f88: fa port map(a => wire(171), b => wire(173), cin => wire(175), s => wire(177), cout => wire(178));
    f89: fa port map(a => wire(145), b => wire(147), cin => wire(149), s => wire(179), cout => wire(180));
    f90: fa port map(a => wire(177), b => wire(151), cin => wire(153), s => wire(181), cout => wire(182));
    f91: fa port map(a => wire(179), b => wire(181), cin => wire(155), s => arg1(14), cout => arg2(15));

    --column 16--
    h16: ha port map(a => layer1_r1(15), b => layer1_r2(15), s => wire(183), c => wire(184));
    f92: fa port map(a => layer1_r3(15), b => layer1_r4(15), cin => layer1_r5(15), s => wire(185), cout => wire(186));
    f93: fa port map(a => layer1_r6(15), b => layer1_r7(15), cin => layer1_r8(15), s => wire(187), cout => wire(188));
    f94: fa port map(a => layer1_r9(15), b => layer1_r10(15), cin => layer1_r11(15), s => wire(189), cout => wire(190));

    f95: fa port map(a => layer1_r12(15), b => layer1_r13(15), cin => layer1_r14(15), s => wire(191), cout => wire(192));
    f96: fa port map(a => layer1_r15(15), b => layer1_r16(15), cin => layer1_r17(15), s => wire(193), cout => wire(194));
    f97: fa port map(a => wire(183), b => wire(185), cin => wire(187), s => wire(195), cout => wire(196));
    f98: fa port map(a => wire(157), b => wire(160), cin => wire(162), s => wire(197), cout => wire(198));

    f99: fa port map(a => wire(189), b => wire(191), cin => wire(193), s => wire(199), cout => wire(200));
    f100: fa port map(a => wire(195), b => wire(197), cin => wire(164), s => wire(201), cout => wire(202));
    f101: fa port map(a => wire(166), b => wire(168), cin => wire(170), s => wire(203), cout => wire(204));

    f102: fa port map(a => wire(199), b => wire(201), cin => wire(203), s => wire(205), cout => wire(206));
    f103: fa port map(a => wire(172), b => wire(174), cin => wire(176), s => wire(207), cout => wire(208));

    f104: fa port map(a => wire(205), b => wire(178), cin => wire(180), s => wire(209), cout => wire(210));
    
    f105: fa port map(a => wire(207), b => wire(182), cin => wire(209), s => arg1(15), cout => arg2(16));

    --column 17--
    h17: ha port map(a => layer1_r1(16), b => layer1_r3(16), s => wire(211), c => wire(212)); 
    f106: fa port map(a => layer1_r4(16), b => layer1_r5(16), cin => layer1_r6(16), s => wire(213), cout => wire(214));
    f107: fa port map(a => layer1_r7(16), b => layer1_r8(16), cin => layer1_r9(16), s => wire(215), cout => wire(216));
    f108: fa port map(a => layer1_r10(16), b => layer1_r11(16), cin => layer1_r12(16), s => wire(217), cout => wire(218));

    f109: fa port map(a => layer1_r13(16), b => layer1_r14(16), cin => layer1_r15(16), s => wire(219), cout => wire(220));
    f110: fa port map(a => layer1_r16(16), b => layer1_r17(16), cin => wire(211), s => wire(221), cout => wire(222));
    f111: fa port map(a => wire(213), b => wire(215), cin => wire(190), s => wire(223), cout => wire(224));
    f112: fa port map(a => wire(184), b => wire(186), cin => wire(188), s => wire(225), cout => wire(226));

    f113: fa port map(a => wire(217), b => wire(219), cin => wire(221), s => wire(227), cout => wire(228));
    f114: fa port map(a => wire(223), b => wire(225), cin => wire(192), s => wire(229), cout => wire(230));
    f115: fa port map(a => wire(194), b => wire(196), cin => wire(198), s => wire(231), cout => wire(232));

    f116: fa port map(a => wire(227), b => wire(229), cin => wire(231), s => wire(233), cout => wire(234));  
    f117: fa port map(a => wire(200), b => wire(202), cin => wire(204), s => wire(235), cout => wire(236)); 

    f118: fa port map(a => wire(233), b => wire(206), cin => wire(208), s => wire(237), cout => wire(238));

    f119: fa port map(a => wire(235), b => wire(237), cin => wire(210), s => arg1(16), cout => arg2(17));

    --column 18--
    f120: fa port map(a => layer1_r1(17), b => layer1_r4(17), cin => layer1_r5(17), s => wire(239), cout => wire(240)); 
    f121: fa port map(a => layer1_r6(17), b => layer1_r7(17), cin => layer1_r8(17), s => wire(241), cout => wire(242)); 
    f122: fa port map(a => layer1_r9(17), b => layer1_r10(17), cin => layer1_r11(17), s => wire(243), cout => wire(244)); 
    f123: fa port map(a => layer1_r12(17), b => layer1_r13(17), cin => layer1_r14(17), s => wire(245), cout => wire(246)); 
    f124: fa port map(a => layer1_r15(17), b => layer1_r16(17), cin => layer1_r17(17), s => wire(247), cout => wire(248)); 
    f125: fa port map(a => wire(239), b => wire(241), cin => wire(212), s => wire(249), cout => wire(250)); 
    f126: fa port map(a => wire(214), b => wire(216), cin => wire(218), s => wire(251), cout => wire(252)); 
    f127: fa port map(a => wire(243), b => wire(245), cin => wire(247), s => wire(253), cout => wire(254)); 
    f128: fa port map(a => wire(249), b => wire(251), cin => wire(220), s => wire(255), cout => wire(256)); 
    f129: fa port map(a => wire(222), b => wire(224), cin => wire(226), s => wire(257), cout => wire(258)); 
    f130: fa port map(a => wire(253), b => wire(255), cin => wire(257), s => wire(259), cout => wire(260)); 
    f131: fa port map(a => wire(228), b => wire(230), cin => wire(232), s => wire(261), cout => wire(262)); 
    f132: fa port map(a => wire(259), b => wire(234), cin => wire(236), s => wire(263), cout => wire(264)); 
    f133: fa port map(a => wire(261), b => wire(263), cin => wire(238), s => arg1(17), cout => arg2(18));

    --column 19--
    f134: fa port map(a => layer1_r1(18), b => layer1_r5(18), cin => layer1_r6(18), s => wire(265), cout => wire(266));
    f135: fa port map(a => layer1_r7(18), b => layer1_r8(18), cin => layer1_r9(18), s => wire(267), cout => wire(268));
    f136: fa port map(a => layer1_r10(18), b => layer1_r11(18), cin => layer1_r12(18), s => wire(269), cout => wire(270));
    f137: fa port map(a => layer1_r13(18), b => layer1_r14(18), cin => layer1_r15(18), s => wire(271), cout => wire(272));
    f138: fa port map(a => layer1_r16(18), b => layer1_r17(18), cin => wire(265), s => wire(273), cout => wire(274));
    f139: fa port map(a => wire(240), b => wire(242), cin => wire(244), s => wire(275), cout => wire(276));
    f140: fa port map(a => wire(267), b => wire(269), cin => wire(271), s => wire(277), cout => wire(282));
    f141: fa port map(a => wire(273), b => wire(275), cin => wire(246), s => wire(278), cout => wire(279));
    f142: fa port map(a => wire(248), b => wire(250), cin => wire(252), s => wire(280), cout => wire(281));
    f143: fa port map(a => wire(277), b => wire(278), cin => wire(280), s => wire(283), cout => wire(284));
    f144: fa port map(a => wire(254), b => wire(256), cin => wire(258), s => wire(285), cout => wire(286));
    f145: fa port map(a => wire(283), b => wire(260), cin => wire(262), s => wire(287), cout => wire(288));
    f146: fa port map(a => wire(285), b => wire(287), cin => wire(264), s => arg1(18), cout => arg2(19));

    --column 20--
    f147: fa port map(a => layer1_r1(19), b => layer1_r6(19), cin => layer1_r7(19), s => wire(289), cout => wire(290));
    f148: fa port map(a => layer1_r8(19), b => layer1_r9(19), cin => layer1_r10(19), s => wire(291), cout => wire(292));
    f149: fa port map(a => layer1_r11(19), b => layer1_r12(19), cin => layer1_r13(19), s => wire(293), cout => wire(294));
    f150: fa port map(a => layer1_r14(19), b => layer1_r15(19), cin => layer1_r16(19), s => wire(295), cout => wire(296));
    f151: fa port map(a => layer1_r17(19), b => wire(266), cin => wire(268), s => wire(297), cout => wire(298));
    f152: fa port map(a => wire(289), b => wire(291), cin => wire(293), s => wire(299), cout => wire(300));
    f153: fa port map(a => wire(295), b => wire(297), cin => wire(270), s => wire(301), cout => wire(302));
    f154: fa port map(a => wire(272), b => wire(274), cin => wire(276), s => wire(303), cout => wire(304));
    f155: fa port map(a => wire(299), b => wire(301), cin => wire(303), s => wire(305), cout => wire(306));
    f156: fa port map(a => wire(282), b => wire(279), cin => wire(281), s => wire(307), cout => wire(308));
    f157: fa port map(a => wire(305), b => wire(284), cin => wire(286), s => wire(309), cout => wire(310));
    f158: fa port map(a => wire(307), b => wire(309), cin => wire(288), s => arg1(19), cout => arg2(20));

    --column 21--
    f159: fa port map(a => layer1_r1(20), b => layer1_r7(20), cin => layer1_r8(20), s => wire(311), cout => wire(312));
    f160: fa port map(a => layer1_r9(20), b => layer1_r10(20), cin => layer1_r11(20), s => wire(313), cout => wire(314));
    f161: fa port map(a => layer1_r12(20), b => layer1_r13(20), cin => layer1_r14(20), s => wire(315), cout => wire(316));
    f162: fa port map(a => layer1_r15(20), b => layer1_r16(20), cin => wire(290), s => wire(317), cout => wire(318));
    f163: fa port map(a => layer1_r17(20), b => wire(311), cin => wire(313), s => wire(319), cout => wire(320));
    f164: fa port map(a => wire(315), b => wire(317), cin => wire(292), s => wire(321), cout => wire(322));
    f165: fa port map(a => wire(294), b => wire(296), cin => wire(298), s => wire(323), cout => wire(324));
    f166: fa port map(a => wire(319), b => wire(321), cin => wire(323), s => wire(325), cout => wire(326));
    f167: fa port map(a => wire(300), b => wire(302), cin => wire(304), s => wire(327), cout => wire(328));
    f168: fa port map(a => wire(325), b => wire(306), cin => wire(308), s => wire(329), cout => wire(330));
    f169: fa port map(a => wire(327), b => wire(329), cin => wire(310), s => arg1(20), cout => arg2(21));

    --column 22--
    f170: fa port map(a => layer1_r1(21), b => layer1_r8(21), cin => layer1_r9(21), s => wire(331), cout => wire(423)); 
    f171: fa port map(a => layer1_r10(21), b => layer1_r11(21), cin => layer1_r12(21), s => wire(332), cout => wire(333)); 
    f172: fa port map(a => layer1_r13(21), b => layer1_r14(21), cin => layer1_r15(21), s => wire(334), cout => wire(335)); 
    f173: fa port map(a => layer1_r16(21), b => layer1_r17(21), cin => wire(331), s => wire(336), cout => wire(337)); 
    f174: fa port map(a => wire(332), b => wire(334), cin => wire(312), s => wire(338), cout => wire(339)); 
    f175: fa port map(a => wire(314), b => wire(316), cin => wire(318), s => wire(340), cout => wire(341)); 
    f176: fa port map(a => wire(336), b => wire(338), cin => wire(340), s => wire(342), cout => wire(343));
    f177: fa port map(a => wire(320), b => wire(322), cin => wire(324), s => wire(344), cout => wire(345));
    f178: fa port map(a => wire(342), b => wire(326), cin => wire(328), s => wire(346), cout => wire(347));
    f179: fa port map(a => wire(344), b => wire(346), cin => wire(330), s => arg1(21), cout => arg2(22));

    --column 23--
    f180: fa port map(a => layer1_r1(22), b => layer1_r9(22), cin => layer1_r10(22), s => wire(348), cout => wire(349)); 
    f181: fa port map(a => layer1_r11(22), b => layer1_r12(22), cin => layer1_r13(22), s => wire(350), cout => wire(351)); 
    f182: fa port map(a => layer1_r14(22), b => layer1_r15(22), cin => layer1_r16(22), s => wire(353), cout => wire(354)); 
    f183: fa port map(a => layer1_r17(22), b => wire(348), cin => wire(350), s => wire(355), cout => wire(356)); 
    f184: fa port map(a => wire(423), b => wire(333), cin => wire(335), s => wire(357), cout => wire(358)); 
    f185: fa port map(a => wire(353), b => wire(355), cin => wire(357), s => wire(359), cout => wire(360)); 
    f186: fa port map(a => wire(337), b => wire(339), cin => wire(341), s => wire(361), cout => wire(362)); 
    f187: fa port map(a => wire(359), b => wire(343), cin => wire(345), s => wire(363), cout => wire(364));
    f188: fa port map(a => wire(361), b => wire(363), cin => wire(347), s => arg1(22), cout => arg2(23));

    --column 24--
    f189: fa port map(a => layer1_r1(23), b => layer1_r10(23), cin => layer1_r11(23), s => wire(365), cout => wire(366));
    f190: fa port map(a => layer1_r12(23), b => layer1_r13(23), cin => layer1_r14(23), s => wire(367), cout => wire(368));
    f191: fa port map(a => layer1_r15(23), b => layer1_r16(23), cin => layer1_r17(23), s => wire(369), cout => wire(370));
    f192: fa port map(a => wire(365), b => wire(349), cin => wire(351), s => wire(371), cout => wire(372));
    f193: fa port map(a => wire(367), b => wire(369), cin => wire(371), s => wire(373), cout => wire(374));
    f194: fa port map(a => wire(354), b => wire(356), cin => wire(358), s => wire(375), cout => wire(376));
    f195: fa port map(a => wire(373), b => wire(360), cin => wire(362), s => wire(377), cout => wire(378));
    f196: fa port map(a => wire(375), b => wire(377), cin => wire(364), s => arg1(23), cout => arg2(24));

    --column 25--
    f197: fa port map(a => layer1_r1(24), b => layer1_r11(24), cin => layer1_r12(24), s => wire(379), cout => wire(380));
    f198: fa port map(a => layer1_r13(24), b => layer1_r14(24), cin => layer1_r15(24), s => wire(381), cout => wire(382));
    f199: fa port map(a => layer1_r16(24), b => layer1_r17(24), cin => wire(366), s => wire(383), cout => wire(384));
    f200: fa port map(a => wire(379), b => wire(381), cin => wire(383), s => wire(385), cout => wire(386));
    f201: fa port map(a => wire(368), b => wire(370), cin => wire(372), s => wire(387), cout => wire(388));
    f202: fa port map(a => wire(385), b => wire(374), cin => wire(376), s => wire(389), cout => wire(390));
    f203: fa port map(a => wire(387), b => wire(389), cin => wire(378), s => arg1(24), cout => arg2(25));

    --column 26--
    f204: fa port map(a => layer1_r1(25), b => layer1_r12(25), cin => layer1_r13(25), s => wire(391), cout => wire(392));
    f205: fa port map(a => layer1_r14(25), b => layer1_r15(25), cin => layer1_r16(25), s => wire(393), cout => wire(394));
    f206: fa port map(a => layer1_r17(25), b => wire(391), cin => wire(393), s => wire(395), cout => wire(396));
    f207: fa port map(a => wire(380), b => wire(382), cin => wire(384), s => wire(397), cout => wire(398));
    f208: fa port map(a => wire(395), b => wire(386), cin => wire(388), s => wire(399), cout => wire(400));
    f209: fa port map(a => wire(399), b => wire(390), cin => wire(397), s => arg1(25), cout => arg2(26));

    --column 27--
    f210: fa port map(a => layer1_r1(26), b => layer1_r13(26), cin => layer1_r14(26), s => wire(401), cout => wire(402));
    f211: fa port map(a => layer1_r15(26), b => layer1_r16(26), cin => layer1_r17(26), s => wire(403), cout => wire(404));
    f212: fa port map(a => wire(401), b => wire(392), cin => wire(394), s => wire(405), cout => wire(406));
    f213: fa port map(a => wire(403), b => wire(396), cin => wire(398), s => wire(407), cout => wire(408));
    f214: fa port map(a => wire(405), b => wire(407), cin => wire(400), s => arg1(26), cout => arg2(27));

    --column 28--
    f215: fa port map(a => layer1_r1(27), b => layer1_r14(27), cin => layer1_r15(27), s => wire(409), cout => wire(410)); --Done
    f216: fa port map(a => layer1_r16(27), b => layer1_r17(27), cin => wire(402), s => wire(411), cout => wire(412));
    f217: fa port map(a => wire(409), b => wire(404), cin => wire(406), s => wire(413), cout => wire(414));
    f218: fa port map(a => wire(411), b => wire(413), cin => wire(408), s => arg1(27), cout => arg2(28));

    --column 29--
    f219: fa port map(a => layer1_r1(28), b => layer1_r15(28), cin => layer1_r16(28), s => wire(415), cout => wire(416));
    f220: fa port map(a => layer1_r17(28), b => wire(410), cin => wire(412), s => wire(417), cout => wire(418));
    f221: fa port map(a => wire(415), b => wire(417), cin => wire(414), s => arg1(28), cout => arg2(29));

    --column 30--
    f222: fa port map(a => layer1_r1(29), b => layer1_r16(29), cin => layer1_r17(29), s => wire(421), cout => wire(422));
    f223: fa port map(a => wire(421), b => wire(418), cin => wire(416), s => arg1(29), cout => arg2(30));

    --column 31--
    f224: fa port map(a => layer1_r1(30), b => layer1_r17(30), cin => wire(422), s => arg1(30), cout => arg2(31));

    --column 32--
    arg1(31) <= layer1_r1(31);
    
    --final adder to compute arg1 + arg2--
    bkadder: brentkung port map(a => arg1, b => arg2, cin => gnd_sig, s => s, cout => cout);
end behave;