module axi_adder_tb;
    localparam W = 8 ;
    localparam N = 3 ;
    logic s_valid, m_ready, clk, rstn ;
    logic [W-1:0] s_data;
    logic m_valid, s_ready;
    
    logic [1:0][6:0] m_data;
    logic [$clog2(N)-1:0] count;

    // Declare the DUT
    axi_adder #(.W(W) , .N(N)) dut(.*);
    
    initial begin
            clk = 0;
            forever #5 clk = ~clk;
        end
        
    initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars ; 
    #10
    
    @(posedge clk) #1 s_data<=3  ; rstn<=1 ; s_valid<=1; m_ready<=1;
    
    @(posedge clk) #1 s_data<=2 ; rstn<=1 ; s_valid<=1; m_ready<=1;
  
    @(posedge clk) #1 s_data<=3 ; rstn<=1 ; s_valid<=1; m_ready<=1; 
    @(posedge clk) #1 s_data<=4 ; rstn<=1 ; s_valid<=1; m_ready<=1;
  
    @(posedge clk) #1 s_data<=1 ; rstn<=1 ; s_valid<=1; m_ready<=0;
    @(posedge clk) #1 s_data<=6 ; rstn<=1 ; s_valid<=1; m_ready<=0;

    @(posedge clk)#1  s_data<=5 ; rstn<=1 ; s_valid<=1; m_ready<=1;

    @(posedge clk)#1  s_data<=4 ; rstn<=1 ; s_valid<=1; m_ready<=1;

    @(posedge clk) #1 s_data<=3  ; rstn<=1 ; s_valid<=1; m_ready<=0;
        
    @(posedge clk) #1 s_data<=2 ; rstn<=1 ; s_valid<=1; m_ready<=1;

    @(posedge clk) #1 s_data<=3 ; rstn<=1 ; s_valid<=1; m_ready<=1; 
    @(posedge clk) #1 s_data<=4 ; rstn<=1 ; s_valid<=1; m_ready<=1;
  
    @(posedge clk) #1 s_data<=1 ; rstn<=1 ; s_valid<=1; m_ready<=0;
    @(posedge clk) #1 s_data<=6 ; rstn<=1 ; s_valid<=1; m_ready<=0;
    
    @(posedge clk)#1  s_data<=5 ; rstn<=1 ; s_valid<=1; m_ready<=1;
    
    @(posedge clk)#1  s_data<=4 ; rstn<=1 ; s_valid<=1; m_ready<=1;


    @(posedge clk) #1  s_data<=1 ; rstn<=1 ; s_valid<=0; m_ready<=1;

    $finish();
    
    end
    
endmodule
