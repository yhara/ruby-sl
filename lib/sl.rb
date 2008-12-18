require 'curses'

module SL

  VERSION = "0.1"

  def self.run!
    init
    run
  end

  def self.init
    Curses.init_screen
    Curses.clear
    Curses.refresh
    Curses.noecho
  end

  def self.run
    h = Curses.lines
    w = Curses.cols
    win = Curses::Window.new(h, w, 0, 0)
    D51.new(h, w).run(win)
  end

  class Actor

    def initialize(lines, cols)
      @lines, @cols = lines, cols
    end

    def putstr(win, y, x, str)
      return if x >= @cols
      if x < 0
        str = str[-x-1 .. -1] or return
        x = 0
      end
      if (x + str.size) >= @cols
        str = str[0 ... (@cols - x)]
      end
      win.setpos(y, x)
      win.addstr(str)
    end

  end

  class Smoke < Actor
    SMOKEPTNS = 16
    Item = Struct.new(:y, :x, :ptrn, :kind)
    Smokes = [["(   )", "(    )", "(    )", "(   )", "(  )",
      "(  )" , "( )"   , "( )"   , "()"   , "()"  ,
      "O"    , "O"     , "O"     , "O"    , "O"   ,
      " "                                          ],
      ["(@@@)", "(@@@@)", "(@@@@)", "(@@@)", "(@@)",
        "(@@)" , "(@)"   , "(@)"   , "@@"   , "@@"  ,
        "@"    , "@"     , "@"     , "@"    , "@"   ,
        " "                                          ]]
    Eraser =  ["     ", "      ", "      ", "     ", "    ",
      "    " , "   "   , "   "   , "  "   , "  "  ,
      " "    , " "     , " "     , " "    , " "   ,
      " "                                          ]

    DY = [ 2,  1, 1, 1, 0, 0, 0, 0, 0, 0,
      0,  0, 0, 0, 0, 0             ]
    DX = [-2, -1, 0, 1, 1, 1, 1, 1, 2, 2,
      2,  2, 2, 3, 3, 3             ]

    def initialize(lines, cols)
      super
      @s = []
      @sum = 0
    end

    def put(win, y, x)
      if (x % 4 == 0)
        @sum.times do |i|
          putstr(win, @s[i].y, @s[i].x, Eraser[@s[i].ptrn]);
          @s[i].y    -= DY[@s[i].ptrn];
          @s[i].x    += DX[@s[i].ptrn];
          @s[i].ptrn += (@s[i].ptrn < SMOKEPTNS - 1) ? 1 : 0;
          putstr(win, @s[i].y, @s[i].x, Smokes[@s[i].kind][@s[i].ptrn]);
        end
        putstr(win, y, x, Smokes[@sum % 2][0]);
        @s[@sum] = Item.new
        @s[@sum].y = y;    @s[@sum].x = x;
        @s[@sum].ptrn = 0; @s[@sum].kind = @sum % 2;
        @sum += 1;
      end
    end

  end

  class D51 < Actor
    HEIGHT = 10
    FUNNEL = 7
    LENGTH = 83
    PATTERNS = 6

    D51_BODY = [
      "      ====        ________                ___________ ",
      "  _D _|  |_______/        \\__I_I_____===__|_________| ",
      "   |(_)---  |   H\\________/ |   |        =|___ ___|   ",
      "   /     |  |   H  |  |     |   |         ||_| |_||   ",
      "  |      |  |   H  |__--------------------| [___] |   ",
      "  | ________|___H__/__|_____/[][]~\\_______|       |   ",
      "  |/ |   |-----------I_____I [][] []  D   |=======|__ "
    ]
    D51_WHEEL = [
      [
        "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
        " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
        "  \\_/      \\O=====O=====O=====O_/      \\_/            ",
    ],
    [
      "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
      " |/-=|___|=O=====O=====O=====O   |_____/~\\___/        ",
      "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",
    ],
    [
      "__/ =| o |=-O=====O=====O=====O \\ ____Y___________|__ ",
      " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
      "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",
    ],
    [
      "__/ =| o |=-~O=====O=====O=====O\\ ____Y___________|__ ",
      " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
      "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",
    ],
    [
      "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
      " |/-=|___|=   O=====O=====O=====O|_____/~\\___/        ",
      "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",
    ],
    [
      "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
      " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
      "  \\_/      \\_O=====O=====O=====O/      \\_/            ",
    ]
    ]
    D51_DEL = "                                                      "

    COAL_BODY = [
      "                              ",
      "                              ",
      "    _________________         ",
      "   _|                \\_____A  ",
      " =|                        |  ",
      " -|                        |  ",
      "__|________________________|_ ",
      "|__________________________|_ ",
      "   |_D__D__D_|  |_D__D__D_|   ",
      "    \\_/   \\_/    \\_/   \\_/    ",
    ]
    COAL_DEL = "                              "


    D51 = D51_WHEEL.map{|wheel|
      D51_BODY + wheel + [D51_DEL]
    }
    COAL = COAL_BODY + [COAL_DEL]

    def initialize(lines, cols)
      super
      @smoke = Smoke.new(lines, cols)
    end

    def run(win)
      x = @cols - 1
      loop do
        break if put_D51(win, x).nil?
        win.refresh
        sleep(0.02)
        x -= 1
      end
    end

    private

    def put_D51(win, x)
      y = i = 0;
      return nil if x < -LENGTH
      y = @lines / 2 - 5

      (0..HEIGHT).each do |i|
        putstr(win, y + i, x, D51[(LENGTH + x) % PATTERNS][i]);
        putstr(win, y + i, x + 53, COAL[i]);
      end
      @smoke.put(win, y - 1, x + FUNNEL);
      return true
    end

  end

end

if $0==__FILE__
  SL.run!
end
