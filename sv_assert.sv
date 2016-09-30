语法：
1.断言一般格式
name: assert property(@(posedge clk) wr_en |=> wr_ack);
$diaplay("success!",$time);
else
$diaplay("failure!",$time);
2. (1) intersect(a,b)———— 断定a和b两个事件同时产生，且同时结束。
   (2) a within b    ———— 断定b事件发生的时间段里包含a事件发生的时间段。
   (3) a ##2 b       ———— 断定a事件发生后2个单位时间内b事件一定会发生。
       a ##[1:3] b   ———— 断定a事件发生后1~3个单位时间内b事件一定会发生。
       a ##[3:$] b   ———— 断定a事件发生后3个周期时间后b事件一定会发生。
   (4) c throughout (a ##2 b)    ———— 断定在a事件成立到b事件成立的过程中，c事件“一直”成立。
   (5) @ (posedge clk) a |-> b   ———— 断定clk上升沿后，a事件“开始发生”，同时，b事件发生。
   (6) @ (posedge clk) a.end |-> b ———— 断定clk上升沿后，a事件执行了一段时间“结束”后，同时，
   (7) @ (posedge clk) a |=> b   ———— 断定clk上升沿后，a事件开始发生，下一个时钟沿后，b事件开始发生。      
   (8) @ (posedge clk) a |=>##2b ———— 断定clk上升沿后，a事件开始发生，下三个时钟沿后，b事件开始发生。
   (9) @ (posedge clk) $past(a,2) == 1'b1 ———— 断定a信号在2个时钟周期“以前”，其电平值是1。
   (10) @ (posedge clk) a [*3] ———— 断定“@ (posedge clk) a”在连续3个时钟周期内都成立。
        @ (posedge clk) a [*1:3] ———— 断定“@ (posedge clk) a”在连续1~3个时钟周期内都成立。
        @ (posedge clk) a [->3] ———— 断定“@ (posedge clk) a”在非连续的3个时钟周期内都成立。
    
3. 语法6：屏蔽不定态
    当信号被断言时，如果信号是未复位的不定态，不管怎么断言，都会报告：“断言失败”，为了在不定态不报告问题，在断言时可以屏蔽。
    如： @(posedge clk) (q == $past(d))，当未复位时报错，屏蔽方法是将该句改写为：
         @(posedge clk) disable iff (!rst_n) (q == $past(d))  //rst是低电平有效



实例：
1.FIFO write assertion
fifo_wr: assert property(@(posedge I_wr_clk) wr_en |-> ##1 wr_ack);
$diaplay("success!",$time);
else
$diaplay("failure!",$time);
