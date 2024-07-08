module hockey(

    input clk,
    input rst,

    input BTNA,
    input BTNB,

    input [1:0] DIRA,
    input [1:0] DIRB,

    input [2:0] YA,
    input [2:0] YB,

    output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,

    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4,
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0 ,

    output reg [2:0] XCOORD,
    output reg [2:0] YCOORD

  );



  reg turn;
  reg [3:0] state;

  reg starttimer;
  reg [8:0] timer;
  reg [1:0] dirY;

  reg [1:0] scoreA;
  reg [1:0] scoreB;

  parameter IDLE = 4'b0000;
  parameter DSP = 4'b0001;
  parameter HITB = 4'b0010;
  parameter HITA = 4'b0011;
  parameter SENDB = 4'b0100;
  parameter SENDA = 4'b0101;
  parameter RESPA =4'b0110;
  parameter RESPB =4'b0111;
  parameter GOALA =4'b1000;
  parameter GOALB =4'b1001;
  parameter FINISH = 4'b1010;
  parameter BLINK = 4'b1011;

  parameter ZERO = 7'b0000001;
  parameter ONE = 7'b1001111;
  parameter TWO = 7'b0010010;
  parameter THREE = 7'b0000110;
  parameter FOUR = 7'b1001100;
  parameter NONE = 7'b1111111;


  reg [1:0] buttons;

  // you may use additional always blocks or drive SSDs and LEDs in one always block
  // for state machine and memory elements
  always @(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      state <= IDLE;
      XCOORD = 0;
      YCOORD = 0;
      timer <= 0;
      scoreA <= 0;
      scoreB <= 0;
    end
    else
    case(state)
      IDLE:
      begin
        buttons = {BTNA,BTNB};
        case(buttons)
          2'b01:
          begin
            turn <= 1'b1;
            state <= DSP;
          end
          2'b10:
          begin
            turn <= 1'b0;
            state <= DSP;
          end
          default:
          begin
            turn <= 1;
            state <= IDLE;
          end
        endcase
      end

      DSP:
      begin
        if(timer < 100)
        begin
          timer <= timer+1;
          state <= DSP;
        end
        else
        begin
          $display("hdfkasfgka");
          if(turn)
            state <= HITB;
          else
            state <= HITA;
          timer <= 0;
        end
      end

      HITB:
      begin
        if(BTNB && YB < 5)
        begin
          XCOORD <= 4;
          YCOORD <= YB;
          dirY <= DIRB;
          state <= SENDA;
        end
        else
          state <= HITB;
      end

      HITA:
      begin
        if(BTNA && YA < 5)
        begin
          XCOORD <= 0;
          YCOORD <= YA;
          dirY <= DIRA;
          state <= SENDB;
        end
        else
          state <= HITA;
      end

      SENDA:
      begin
        if(timer < 100)
        begin
          timer <= timer+1;
          state <= SENDA;
        end
        else
        begin
          timer <= 0;
          if(dirY == 2'b10)
          begin

            if(YCOORD == 3'b000)
            begin
              dirY <= 2'b01;
              YCOORD <= YCOORD + 1;
            end

            else
              YCOORD <= YCOORD - 1;
          end

          else if(dirY == 2'b01)
          begin

            if(YCOORD == 3'b100)
            begin
              dirY <= 2'b10;
              YCOORD <= YCOORD - 1;
            end

            else
              YCOORD <= YCOORD + 1;
          end

          if(XCOORD > 1)
          begin
            XCOORD <= XCOORD-1;
            state <= SENDA;
          end
          else
          begin
            XCOORD <= 0;
            state <= RESPA;
          end
        end
      end

      SENDB:
      begin
        if(timer < 100)
        begin
          timer <= timer+1;
          state <= SENDB;
        end
        else
        begin
          timer <= 0;
          if(dirY == 2'b10)
          begin

            if(YCOORD == 3'b000)
            begin
              dirY <= 2'b01;
              YCOORD <= YCOORD + 1;
            end

            else
              YCOORD <= YCOORD - 1;
          end

          else if(dirY == 2'b01)
          begin

            if(YCOORD == 3'b100)
            begin
              dirY <= 2'b10;
              YCOORD <= YCOORD - 1;
            end

            else
              YCOORD <= YCOORD + 1;
          end


          if(XCOORD < 3 )
          begin
            XCOORD <= XCOORD + 1;
            state <= SENDB;
          end
          else
          begin
            XCOORD <= 4;
            state <= RESPB;
          end
        end
      end

      RESPA:
      begin
        if(timer < 100)
        begin
          if(BTNA && YCOORD == YA)
          begin
            XCOORD <= 1;
            timer <= 0;
            if(DIRB == 2'b00)
            begin
              dirY <= DIRB;
            end
            else if(DIRB == 2'b01)
            begin
              if(YCOORD == 4)
              begin
                dirY <= 2'b10;
                YCOORD <= YCOORD -1;
              end
              else
              begin
                dirY <= DIRA;
                YCOORD <= YCOORD + 1;
              end
            end
            else if(DIRB == 2'b10)
            begin
              if(YCOORD == 0)
              begin
                dirY <= 2'b01;
                YCOORD <= YCOORD + 1;
              end
              else
              begin
                dirY <= DIRA;
                YCOORD <= YCOORD - 1;
              end
            end
            else
            begin
              state <= IDLE;
            end
            state <= SENDB;
          end
          else
            timer <= timer + 1;
        end
        else
        begin
          timer <= 0;
          scoreB <= scoreB + 1;
          state <= GOALB;
        end
      end

      RESPB:
      begin
        if(timer < 100)
        begin
          if(BTNB && YCOORD == YB)
          begin
            XCOORD <= 3;
            timer <= 0;
            if(DIRA == 2'b00)
            begin
              dirY <= DIRA;
            end
            else if(DIRA == 2'b01)
            begin
              if(YCOORD == 4)
              begin
                dirY <= 2'b10;
                YCOORD <= YCOORD -1;
              end
              else
              begin
                dirY <= DIRB;
                YCOORD <= YCOORD + 1;
              end
            end
            else if(DIRA == 2'b10)
            begin
              if(YCOORD == 0)
              begin
                dirY <= 2'b01;
                YCOORD <= YCOORD + 1;
              end
              else
              begin
                dirY <= DIRB;
                YCOORD <= YCOORD - 1;
              end
            end
            else
              state <= IDLE;
            state <= SENDA;
          end
          else
            timer <= timer + 1;
        end
        else
        begin
          timer <= 0;
          scoreA <= scoreA + 1;
          state <= GOALA;
        end
      end

      GOALB:
      begin
        if(timer < 100)
        begin
          timer <= timer + 1;
          state <= GOALB;
        end
        else
        begin
          timer <= 0;
          if(scoreB == 3)
          begin
            turn <= 1;
            state <= FINISH;
          end
          else
            state <= HITA;
        end
      end

      GOALA:
      begin
        if(timer < 100)
        begin
          timer <= timer + 1;
          state <= GOALA;
        end
        else
        begin
          timer <= 0;
          if(scoreA == 3)
          begin
            turn <= 0;
            state <= FINISH;
          end
          else
            state <= HITB;
        end
      end

      FINISH:
        if(timer < 25)
        begin
          timer <= timer +1;
          state <= FINISH;
        end
        else
        begin
          timer <= 0;
          state <= BLINK;
        end
      BLINK:
        if(timer < 25)
        begin
          timer <= timer +1;
          state <= BLINK;
        end
        else
        begin
          timer <= 0;
          state <= FINISH;
        end

      default state <= IDLE;
    endcase

  end

  // for SSDs
  always @ (*)
  begin

    case(state)
      IDLE:
      begin
        SSD0 = NONE;
        SSD1 = NONE;
        SSD2 = NONE;
        SSD3 = NONE;
        SSD4 = NONE;
        SSD5 = NONE;
        SSD6 = NONE;
        SSD7 = NONE;
      end
      DSP:
      begin
        if(scoreB == 0)
          SSD0 = ZERO;
        else if(scoreB == 1)
          SSD0 = ONE;
        else if(scoreB == 2)
          SSD0 = TWO;
        else if(scoreB == 3)
          SSD0 = THREE;
        else
          SSD0 = NONE;

        SSD1 = 7'b1111110;

        if(scoreA == 0)
          SSD2 = ZERO;
        else if(scoreA == 1)
          SSD2 = ONE;
        else if(scoreA == 2)
          SSD2 = TWO;
        else if(scoreA == 3)
          SSD2 = THREE;
        else
          SSD2 = NONE;

        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;

        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end
      HITA:
      begin
        SSD0 = NONE;
        SSD1 = NONE;
        SSD2 = NONE;
        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;


        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end
      HITB:
      begin
        SSD0 = NONE;
        SSD1 = NONE;
        SSD2 = NONE;
        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;


        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end
      SENDA:
      begin
        SSD0 = NONE;
        SSD1 = NONE;
        SSD2 = NONE;
        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;


        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end
      SENDB:
      begin
        SSD0 = NONE;
        SSD1 = NONE;
        SSD2 = NONE;
        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;

        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end
      RESPA:
      begin
        SSD0 = NONE;
        SSD1 = NONE;
        SSD2 = NONE;
        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;


        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end
      RESPB:
      begin
        SSD0 = NONE;
        SSD1 = NONE;
        SSD2 = NONE;
        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;

        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end
      GOALA:
      begin
        if(scoreB == 0)
          SSD0 = ZERO;
        else if(scoreB == 1)
          SSD0 = ONE;
        else if(scoreB == 2)
          SSD0 = TWO;
        else if(scoreB == 3)
          SSD0 = THREE;
        else
          SSD0 = NONE;

        SSD1 = 7'b1111110;

        if(scoreA == 0)
          SSD2 = ZERO;
        else if(scoreA == 1)
          SSD2 = ONE;
        else if(scoreA == 2)
          SSD2 = TWO;
        else if(scoreA == 3)
          SSD2 = THREE;
        else
          SSD2 = NONE;

        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;
        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end
      GOALB:
      begin
        if(scoreB == 0)
          SSD0 = ZERO;
        else if(scoreB == 1)
          SSD0 = ONE;
        else if(scoreB == 2)
          SSD0 = TWO;
        else if(scoreB == 3)
          SSD0 = THREE;
        else
          SSD0 = NONE;

        SSD1 = 7'b1111110;

        if(scoreA == 0)
          SSD2 = ZERO;
        else if(scoreA == 1)
          SSD2 = ONE;
        else if(scoreA == 2)
          SSD2 = TWO;
        else if(scoreA == 3)
          SSD2 = THREE;
        else
          SSD2 = NONE;

        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;

        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end
      FINISH:
      begin
        if(scoreB == 0)
          SSD0 = ZERO;
        else if(scoreB == 1)
          SSD0 = ONE;
        else if(scoreB == 2)
          SSD0 = TWO;
        else if(scoreB == 3)
          SSD0 = THREE;
        else
          SSD0 = NONE;

        SSD1 = 7'b1111110;

        if(scoreA == 0)
          SSD2 = ZERO;
        else if(scoreA == 1)
          SSD2 = ONE;
        else if(scoreA == 2)
          SSD2 = TWO;
        else if(scoreA == 3)
          SSD2 = THREE;
        else
          SSD2 = NONE;

        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;

        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end

      BLINK:

      begin
        if(scoreB == 0)
          SSD0 = ZERO;
        else if(scoreB == 1)
          SSD0 = ONE;
        else if(scoreB == 2)
          SSD0 = TWO;
        else if(scoreB == 3)
          SSD0 = THREE;
        else
          SSD0 = NONE;

        SSD1 = 7'b1111110;

        if(scoreA == 0)
          SSD2 = ZERO;
        else if(scoreA == 1)
          SSD2 = ONE;
        else if(scoreA == 2)
          SSD2 = TWO;
        else if(scoreA == 3)
          SSD2 = THREE;
        else
          SSD2 = NONE;

        SSD3 = NONE;

        if(YCOORD == 0)
          SSD4 = ZERO;
        else if(YCOORD == 1)
          SSD4 = ONE;
        else if(YCOORD == 2)
          SSD4 = TWO;
        else if(YCOORD == 3)
          SSD4 = THREE;
        else if(YCOORD == 4)
          SSD4 = FOUR;
        else
          SSD4 = NONE;

        SSD5 = NONE;

        SSD6 = NONE;
        SSD7 = NONE;
      end

      default:
      begin
        SSD0 = NONE;
        SSD1 = NONE;
        SSD2 = NONE;
        SSD3 = NONE;
        SSD4 = NONE;
        SSD5 = NONE;
        SSD6 = NONE;
        SSD7 = NONE;
      end

    endcase
  end


  //for LEDs
  always @ (*)
  begin
    case(state)
      IDLE:
      begin
        LEDA = 0;
        LEDB = 0;
        LEDX = 0;
      end
      DSP:
      begin
        LEDA = 0;
        LEDB = 0;
        LEDX = 0;
      end
      HITA:
      begin
        LEDA = 1;
        LEDB = 0;
        LEDX = 0;
      end
      HITB:
      begin
        LEDA = 0;
        LEDB = 1;
        LEDX = 0;
      end
      SENDA:
      begin
        LEDA = 0;
        LEDB = 0;
        if(XCOORD == 0)
          LEDX = 1;
        else if(XCOORD == 1)
          LEDX = 2;
        else if(XCOORD == 2)
          LEDX = 4;
        else if(XCOORD == 3)
          LEDX = 8;
        else if(XCOORD == 4)
          LEDX = 16;
      end
      SENDB:
      begin
        LEDA = 0;
        LEDB = 0;
        if(XCOORD == 0)
          LEDX = 1;
        else if(XCOORD == 1)
          LEDX = 2;
        else if(XCOORD == 2)
          LEDX = 4;
        else if(XCOORD == 3)
          LEDX = 8;
        else if(XCOORD == 4)
          LEDX = 16;
      end
      RESPA:
      begin
        LEDA = 0;
        LEDB = 0;
        if(XCOORD == 0)
          LEDX = 1;
        else if(XCOORD == 1)
          LEDX = 2;
        else if(XCOORD == 2)
          LEDX = 4;
        else if(XCOORD == 3)
          LEDX = 8;
        else if(XCOORD == 4)
          LEDX = 16;
      end
      RESPB:
      begin
        LEDA = 0;
        LEDB = 0;
        if(XCOORD == 0)
          LEDX = 1;
        else if(XCOORD == 1)
          LEDX = 2;
        else if(XCOORD == 2)
          LEDX = 4;
        else if(XCOORD == 3)
          LEDX = 8;
        else if(XCOORD == 4)
          LEDX = 16;
      end
      GOALA:
      begin
        LEDA = 0;
        LEDB = 0;
        LEDX = 5'b10001;
      end
      GOALB:
      begin
        LEDA = 0;
        LEDB = 0;
        LEDX = 5'b10001;
      end
      FINISH:
      begin
        LEDA = 0;
        LEDB = 0;
        LEDX = 5'b10001;
      end

      BLINK:
      begin
        LEDA = 0;
        LEDB = 0;
        LEDX = 0;
      end

      default:
      begin
        LEDA = 0;
        LEDB = 0;
        LEDX = 0;
      end
    endcase
  end


endmodule
