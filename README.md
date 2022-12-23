Floating-MAC-in-verilog
========================
Floating mac from half precision inputs to single precision output

## 1. Overview   
<img src="https://user-images.githubusercontent.com/120174812/209347487-de64f1ad-5b3e-4102-8723-7c58141c2025.png" width="60%" height="60%" title="fp_mac" alt="fp_mac"></img>   
This FP MAC needs three inputs. Two 16bit half precision inputs to multiply and one 32bit single precision input which is accumulated date from another precede FP_MAC. For the general purpose, the output of floating multiplier is set by single precision. To make a half precision output, need to set the range of inputs of multiplier or set the rule to modify the output out of range.   

## 2. Floating Point Multiplier   
<img src="https://user-images.githubusercontent.com/120174812/209347506-b73421dc-bb60-4872-a466-b49673d1a63a.png" width="60%" height="60%" title="fp_mac" alt="fp_mac"></img>   
Because of the single precision output, there is no round module in floating multiplier. The significand of each half precision inputs has 11bit. So the output of significand multiplier in the floating multiplier will be 22bit. It is smaller than the length of single precision's significand, 24bit. Also, the range of exponent that the single precision can express is much bigger than the sum of it of two single precision inputs.   
At the first step, determine the sign of multiplied output with signs of inputs. At the same time, add the exponents of two inputs. SS is a register that stores some data not used in the stage but will be used in next stages.   
At the second stage, multiply the significands of two inputs. We can use any multiply algorithm for this step. At this project, I used array multiplier.    
First_one module detects the location of the first 1 bit appear.     
With this counted number, normalizer shift the multiplied significand and adjust exponent.      

## 3. Floating Point Adder
<img src="https://user-images.githubusercontent.com/120174812/209347516-9ce69c24-875e-402a-88d4-fab57ed42e95.png" width="60%" height="60%" title="fp_mac" alt="fp_mac"></img>    
Floating point adder is more complicate than the multiplier.    
At the first step, compare the exponents and shift the significand of input that has lower exponent to match with larger exponent. In this picture in2 is the significand of the input that has larger exponent. Also take the signs of inputs to determine how calculate at adder.
At the adder, check the signs first. If the signs are same, the output sign will be the same one. If they are different, the output sign will be the sign of which has the bigger absolute value, the significand. And then, modify the input values. At this architecture, adjust input of smaller absolute value with 2's complement. Then the bitwise addition will be the subtract. This is possible because floating point format data can be divided in sign and absolute value. Maing a alu that can do subtraction as well as addition is way more tricky than just making adder. We can choose proper adder for this part. At this project, 24bit Kogge-Stone adder is selected for the fast calculation.    
If the input signs are different, there is no overflow. Overflow can occur only when the input signs are same. 
Like the multiplier, find the first 1bit of the output of the adder. 
Shift the significand and adjust the exponent following the count value. If there is overflow, the first bit of the output of adder must be 1. That means there is no need to shift the significand. 
At this time, I used the simple rounding algorithm. If the below one of the last bit is 1, add 1 to the upper bit. If the overflow occur because of the round up, do the one bit shifting.


## 4. Upgrade for Perfoemance
<img src="https://user-images.githubusercontent.com/120174812/209347579-d5fdd7dc-752e-484e-9c54-ede63938f8ee.png" width="60%" height="60%" title="fp_mac" alt="fp_mac"></img>     






