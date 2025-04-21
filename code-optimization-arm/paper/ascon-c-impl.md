https://www.youtube.com/watch?v=z35ycllXoFs

okay I'm waiting for the recording to start so I think yes the recording
started so let me summarize again today's topic is to implement ason uh so
ason won the competition as I mentioned n lightweight crypto competition and the winner was announced in February
2023 and I always mention that the final standard is not ready yet but just a few
days ago n published an a initial public draft so this is not the final version
so it might change at the end but this is what they uh provided for the public so I will try
to implement this okay so today we will try to implement this one so as you can
see this is the uh Mis documentation ipd means initial public dra and it says
ason based lightweight cryptography standards for constraint devices authenticated encryption hash and
extendable output function so this document actually includes a lot so let
me go a little bit further and there is an important uh I I recommend you to read
everything but uh there's an important stuff that is mentioned here so also let
me go to index table content and as you can see here it talks about ASCO and
permutation then starts talking about ason AE a 128 so this is the thing that
we are going to implement okay and as you can see there are Parts where you see encryption decryption Etc so hash
function is also here so but we are not going to implement that so I mentioned
this 128bit stuff because there is a this part says differences from the ason
submission version 1.2 so in my previous implementation I
actually focused on ason submission and in the ason submission there were actually two variants so if they were uh
Asom and Asom 128a as you can see so the rate and
capacity were different in these cases and there is also one version 0pq which
was a version that is you know just for the Post Quantum cryptography but this
document says that this standard specifies the ason a e a 128 algorithm which
is based on ason 128 a so this is the difference so in my
previous I mean in the lectures and in my implementations I always focused on this version because we we thought that
this will be the one that is going to be standardized but it looks like nist is
going to standardize this one and modify it with this name so we will implement this one okay so before implementing let
me see if our uh Visual Studio works correctly so I will simply include
standard libraries standard input output Library okay
so start with the main function and say
prints F hello world
okay and let's see if it works okay so
maybe this voice and do not return anything so let me first
compile this is for the sanity check and it failed
already ah I forgot to SL n here sorry for that yes if we run it it says hello
world so good we are good to go okay so let's go to document and see actually
what we are going to implement let me go to the big picture which we always focused on so
far okay so here it explains parts of asome
but then here is the part of the main picture Okay so as you can see there's
an ason permutation which is R 12 times at the initialization part and it takes
IV key andal as the internal State and recall that our internal state was
simply five rows of 64 bits so let's start implementing these first okay so
first I will hype the the since we are going to work on 64 bits I need an
unsigned uh variable for this so the unsigned long in actually
is referred to like this in Visual Studio but it's is
uh unsigned long long in most probably in many other
uh compilers and I will simply name it as bit 64 okay so I would like
to uh refer to is act
yes okay so whenever I say for instance here I will say B
64 X5 this will create an array of 64bit
values of five variables okay so let me raas this one and it is always good to
initialize everything to zero it's not determined yet so recall that we will
have an IV which is also 64 bits okay
so I will write it later we will need key values
which is 128 bit so I will simply refer as key Z and key1 so we can
also type them as 0 0 and we will have need no
okay 64 no which is also 128 bits okay and
simply write this right so let's initially initialize everything to zero
then we can modify it as we go okay so recall that these values will be fed
into the internal States and then you know we will apply the permutation so
initialization phase actually takes these values right so we need an initialization function
like initialization
which simply takes these inputs which are you know the r States
IV key and no right and of course since there's no
such a function if I run this I will re receive an run time eror so I Define a
function initialization like this okay
and it will take input like 64
sorry of an array in the past you need to specify
the size of the arrays but now you don't have to so we can simply write
five yes sir sir please can you increase your
screen yes yeah thank you you're welcome okay so it will take IV I
don't know why it's there is a error here okay about the TT so we haven't
finished writing it yet so it will take B 64 s
key and also B 64 no
okay it's also I mean you don't have to write the uh arring sizes it will take
them as input but you know to avoid uh wrong memory accesses it is
generally better idea to write it so if you don't write the initialization I mean what we do inside this is referred
to as actually declarated programming as you can see I started the writing as the main function then I realized that I
need to do the initialization right simply I call a function named initialization and I simply claim that
there's a function as initialization but I haven't wrot it down yet so this is called declarative programming we
actually de as if something is there the actually for it is done it does the initialization right I mean because you
call it all I need to do is now write what the initialization does so actually
if you recall let's go to the document and see that the initial state is first
64 B is IV following 128 B is K the secret key and the following 128 bits
are the no so you need to write it like this so x0 must be the IV
right so X1 will be the first part of the
key
t0 then I cop T this because it's two you should always be course ter copy
pasting stuff in C programming but anyway next part is no X3 will Beal to m
z right and X4 will
be one so now we have done the initial part of the initialization if you go
back the picture now what we need is to perform the as on permutation 12 times
right so actually let's say that there is a function called p and we run it
for 12 times right e is less than 12
e okay and we do the permutation
right so permutation needs to be applied on the internal state so I will send X
as the one of the parameters to this permutation so I don't know if I need to add any other parer so again this is the
style of declarated programming I call the permutation P but actually I don't have it yet so I Go Again upwards and
Define the permutation P So currently it simply take the
input 64 X5 so I will determine if in the future I
need anything more okay so as you can see if you compile actually I should
compile from time to time to see if I do any mistake so the compilation is successful apparently I didn't do any
programming error but currently actually this doesn't anything right it does the initialization function and it runs the
P function 12 times but the permutation the P function is not there yet so we have to implement so we have to go and
see what is is done inside this P so recall that this is inside the document
defined like this so let me go upwards yeah as on
permutations as you can see it performs first constants addition then
substitution layer then the linear layer right so let's start with the uh
constant addition okay I I
think yeah in the official ason document the roles were referred to as x0 X1 X2
and I think in this document they referred to as s but it doesn't matter for us okay so constant addition L it
says that there is a table here and the constant is added to the second Ro in
our case it is X2 so this is the list of constants okay so I have to copy paste
so as you can see this is just one b and uh this looks a little bit
different than the original ason constants but anyway you have to do this
one right so I will copy past because there are 16 constants here
probably for some specific reason so I'm just thinking how to copy past it as the
easiest way okay uh let me do this first and see how it
is copied here okay actually we received them
as uh as you can see like this as the value
so let's say that I have constant C of 16 let's say and they are defined
like so I have to put a comma between all of these values so
that the compiler s okay so let me press enter
here to fit it in the screen
yeah and this I guess so yeah I think we are done okay so but which constant you
are adding actually depends on the which run you are right so for this reason
when I call the P permutation as an input I should also send the uh number
of RS I'm in right so this way it knows which value to add so I will also
take uh an integer I we can name it at different way but that integer will be
added so I need to check if we add this this one at the zero Dr so let me
quickly check the document generally it says what
this uh yeah 16 minus runs plus I so we have
to understand this first so let me see
if initially it adds this one or this
one the constant CI of round I of the per as on P round instant with so okay
so this is R&D is the number of runs that we are going to run ason so in our
case the initialization runs this one with 12 so our variable RN is 12 so it
says that the constant 16us 12 + I should be added
so it will be actually here I need to also another
value to because I'm going to run it for 2 so this will be in R
and so X2 is
exort this is the exort symbol by the way in C with the
Conant 16 minus r NB
plus up okay so this is the constant
addition okay and then we need to do so this is
done by the way this is the constant Edition layer it simply does this okay so next step is the perform sbox
operation on every column so this is the tricky part because recall that we are
actually keeping our variables internal state in X5 as 64bit values so if I try to put
5bit input to the sbox I need to for instance take the leftmost bit of x0 then X1 X2 X3 X4 which is very tedious
okay so in order to avoid this in the original documentation of asor they say
that there is actually the algebraic definition of this sbox where you you
define it with the 5bit input and provide the five with output between by introducing logical operations with the
input so let me check if they also added this document or we need to go to the
original ason documentation for that so let's see
then I have to I need to cheat and you know copy paste it from the other
documents okay from this document currently I cannot see if there is such
a thing but let's
see okay apparently it is not included in this document so let me tell show you
what I'm trying to do with our code
okay oh yes so this is As on sbox as you can see it takes five bits input and
provides 5bit output so if I implement this as I mentioned it will be very hard
for me to get all of these values and perform 64 different sboxes but this
sbox is actually logically defined like this so for instance the sbox takes five
input bit right these x0 X1 X2 X3 and X4 actually are not the roles they are
simply Bits and the sbox operation actually performs this exor
and operations or multiplication and for instance there's
an exor bit one which is not operation Etc and provide 5 bit output so if you
just implement this line all of these operations instead of this table look
up you end up with the same results but the good thing is that if I do this
operation not on bits but rows as we do as X2 and X1 then I will
be performing the sbox operation in parallel 64 terms okay that is the thing
so these operations actually in the past we copy pasted it
from uh another document in the
ason uh submission version
1.2 and it works like this so these are I first defined five temporary values
for instance it starts with as you can see x0 xor X4 so let's go to the
document as you can see X4 is exort to x0 and you know X1 is exort to X2 it's
Etc so all of these operations are summarized here so if I'm not mistaken
there are 22 operations maybe 23 I'm not exactly
sure but all of the sbox operations are defined like this so again if you define
this x0 X1 as a single bit this will perform a single sbox operation but our
variables are 64 bit so actually with these lines of quotes we perform
the uh sbox operation 64 times in parall so again I
copy pasted this from the asone documentation in the past so if you also want to do that you can simply go to
asone submission I mean you can go to n website for the
competition and find the ason submission version 1.2 actually it is included in
almost every version of ASCO and you can do these operations so there's also one not you need to know for instance here
in our constant addition I wrote X2 equals to X2 exort this value right so
actually if you are going to exort something with itself and then write it to its own place instead of writing it
like this you can erase this part and say that X2 exor equals to this so this
is why all of these steps are defined like this generally this gives you faster
speed so you should implement it like this if you want the speed but if you don't Implement like this
your compiler might turn it to this anyway if you uh allow optimization flag
so generally it doesn't matter much but you know to see a simplified code this
looks a lot better so instead of uh storing the s
like a table here and running it 64 times we simply did this on 64bit input
so we get R of the sbox so next step
diffusion layer as you can see we take the first row they say s0 we say x0 it
doesn't matter you exort it with 19 bit right rotated version of it and 22 with
right rotation of it so this is actually like this
so X so first maybe we should Define the rotation function to avoid writing it
all the time so we should Define something like this rotate WR it takes
an input and a number of rotations we need to do and we should Define it like
this so X right shifted e times
exort or or with X left shifted sorry X
left shifted 64 minus
I okay right uh let me see our previous Cod so
in the past I used apparently exor not or it doesn't matter but maybe or speed
reasons this might be the case so with this in mind
so let me write this so This Is by the way constant addition this is
sbug now I'm going to write the permutation so permutation means
x0 actually equals to
x0 exort with x0 rotated 19 bits to the right so rotation
of h0 19 right and if I recall correctly it
was also 20 28 times right rotated verion of x0 right this so let me go to
the documentation as you can see x0 19 bits and 25 so the other bits sort for
this S1 it is S1 exor S1 rotated to 61 *
to right and 39 bits to the right so simply let's
copy paste this okay again copy pasting generally leads to error so be careful
when you're modifying it so I will try to do
correctly so this will be like
this I will look at the rotation numbers later let me first change the
variables so this was I think 61 and this one was one let me see yes
10 and seven the other part is
1396 and 17 and 41 if I'm not mistaken so let me
compile it by the way and looks correct right now
so actually this is it now I also have the permutation okay so let's actually do
some sanity checks and try to print the results on theing so let me write a
function called print states which simply
prints the current state so for
equals to zero is less than five since we have five rows
e++ simply print in hexad
decimal x x i so of course as an input we should
take this x values right so this simply prints it
on the screen but uh when in when printing hexadecimal values when there are zeros in at the
beginning actually when you printed the compiler will show you the only the nonzero part so in order to fit the
screen correctly we should fill it with zeros when there are no where the input
part is zero so let me do this so let me print this
states of x so initially we filled with zeros
right so this should print all zero so let me compile this first and run it see
if I'm doing correctly so if there are 64 bits here it should be 16 zeros then this
should be the cor so after the initialization let me print it again and
see if we are doing things correctly right
okay so let me also given maybe we should put
[Music] a ah okay so since this is 64 I think we
should write it like this in Visual Studio let me compile it again
I think correct also let me print of a anle line so distinguish the stuff so
let's compile and now it actually looks correct if I didn't do any
implementation error when your IV key and noes are all zero if you run
the initialization which is 12 rounds of permutation this is the result of your
internal State okay so I'm not sure if I did any mistakes so far we can check at
the end and we don't have an test vector by the way so if I do an error here and
if we don't detect it most probably we will detect it V later okay so at this
point I don't know if I'm doing it correct or not but it looks correct to me so just believe me for a minute okay
so let's rehash we started with this and obtain this but of course I mean the key
is our choice I chose it all zero just for Simplicity nons depends on us but IV
is is actually uh fixed inside the document so let's go to this document
and find what is the IID okay so let me go down at one point it should tell me what
the IV is as you can see initial stat is concatenation of IV key and NOS okay yes
IV is here okay I will copy pass
this okay so I will write it
here so maybe I will take this print State from here and print it before we
do the you know permutation now if we run
it yes this is the result so IV is this keys and noes are selected as zeros and
this is the internal state after 12 rounds of initialization Okay so
currently it looks like we are doing things correctly but I need to look at something else as you can see when you
do the initialization we did this part we fed it with IV key and nose then did the
permutation 12 times then there's an exor here as you can see it says
zero to the top is 64 and then concatenation with the key
this means that okay maybe I should also mention this right as you can see it's writes
128 here 192 here so recall that in a sponge construction this part is called
rate this is capacity so in this version the rate is 128 as I mentioned initial
version of ason actually supports 64bit rate so in the past I implemented that
now we are implementing the 128bit version so capacity is 192 bits
and our secret key is 100 than 28 bits this is why it says that fill the first
64 bits with zero then exort the remaining 128 bits with the key actually
this simply saying that once go to initialization you know we filled with
these values then we run the permutation 12 times now exort the last two R which
is3 with your key
and the last r with the remaining 64 bits of your key okay so now we are done
actually so this is actually what is done for on the left side of this line
okay this vertical line so we have done the initialization and you might see
this kind of exort also here here Etc this is called actually domain
separation because if we don't put it somebody can take this and then put
it here and create false uh Forge a tag for those values okay so for instance
take this line and put it here so this way they can mix the associated data and pl text part Etc okay in order to
separate these worlds by Worlds I mean initialization Associated data PL text
we do something different at the end to you know make make things different so
recall that Associated data is the part where you feed the
your data which is not going to be encrypted as you can see it is not
encrypted here we don't provide any Cipher text but it affects the producing the tag at the end so this part is
optional you may not have an Associated data P so for the sake of speed I won't
going to implement this but it's is I mean just assume that it doesn't exist for our case but adding it will be very
easy at the end okay because we already did the hard part we already implemented the permutation and that's it okay so
assume that I do the initialization actually don't assume it we already done it but assume that
there's no Associated data part now we are going to encrypt some plain text and provide Cipher text
okay good so let's just focus on a case where we have two blocks of plain text
let's encrypted and provide some Cipher text
okay okay so assume that I have a PL
text 64 L
text of uh maybe 256 bits because since
each of them is 64 bit and I create four of them so you know 4 * 64 is it will be
256 which will end up being encrypting two blocks okay so for the sake of let
say I will simply initialize this to zero this to one this to
two this to three of course we can randomly generate it if we want at the end of today okay so I assume that this
is the plain text and at the end I will produce Cipher text
let's initialize it to zero and see at the end if we really encrypt it okay so
I did the initialization right let's now do the encryption
encryption now requires the internal state right and the plane text and I
will also send the enter array Cipher text and it will return me these values
okay but again I don't have a function called encryption as I mentioned this is the style called declarator programming
I will go upwards and now Define a function called
encryption and it will take the values that we wrote there it's
64 X5 so actually the pl text you know can
be very large so I will not def find the its length here so that it will take as
an input you know as long as you want and provide
the the side takes there okay good
St so at this point the encryption function should know how many blocks I'm
going to encrypt so it will be uh actually half of this value
right and you can actually determine it maybe okay let me first print this spe
PS how it measures so let's see how many bytes it
flame so I will save this and write
SI PL text okay and let's see what is
the size of the pl text array okay so let me run this
and it says 32 because there are 32 bytes
here okay so this has
32 and I need actually to divide it by 16 to see how many blocks I'm going to
in so what I'm trying to say is for the encryption you need to do this many Block encryptions in P
equals to zero and E is less
than this [Music]
value divided by
16 e okay so this is how many blocks that you
are going to encrypt and this number will be end up in two okay because we will encryp two blocks okay so let's go
to the picture back so it does the following first exort the pl Tex
128bit PL Tex to the top of the internal state which is rate is 128
right so it does the following
x0 is exort with
uh pz we should say Pi okay and
X1 is exort with t i
+1 so since our variables of 64 bits and
we are actually exerting 128 bits so instead of P I should say PL Tex
sorry in order for this to be correct I need to say 2 * I and 2 * I + 1 right
because in the first encryption it will use PL Tex Z and pl Tex one in the second encryption it will use PL Tex 2
and three four and five Etc okay by the way my antivirus software thinks
that uh I'm creating a virus because you know recently there are many Ransom ver
attacks where actually it does encryption inside so the this is why the
executables I'm creating right now the software antivirus software think that I'm creating a virus so this is why it
gives an okay so but this is what I done so far I exort with this then I need to
run the permutation eight times so at this point Cipher
text again and 2 * I is actually the
result of this exor which is x0 and the other one is plus
one is this okay so let me explain where we are we are currently at this
Parts I exert the pl text to x0 and X1 but also put this as the output s c0
okay now I have to apply the permutation eight times luckily we already
implemented this so what we are going to is do is to call this ah sorry call
this peration eight times at the initialization we called it times now we are calling it eight
times okay let's go to the picture again as
you can see now we are done and everything ends we will do the
tech creation part so but we are currently at the plain Tech site so let's do this then print the cipher text
okay less than four of course generally you will have more cyer texp so I will
simply print up
I okay I will say cyer
text so maybe you like final
empty L okay so let me compile
it okay we receive some errors apparently I did yeah I
haven't hold in what to print actually print side the text
I okay let's recompile apped other errors let's see
yeah I wrote this in ah okay so how did we wrot it in the previous
case Zer on here this was the correct verion I
guess let me see yes
okay apparently it doesn't work as you can see say the cipher text is all zero so I made a mistake this is the good
thing so let's go back and see where we are doing it from okay so I call the
encryption Parts I sent X PL text and Cipher
text so ah okay so size of PL Tex here
actually is not determined here so this actually for never wrong good thing is
that the compiler actually warns me so this is the good thing 10 years ago compilers weren't this clever so you
have to try to find where your mistake was so I mean I if if I cheat here and
simply write two here everything will work but let's do this first I
mean let's see oh it didn't okay let me try to see ah okay I forgot
to rate the device by 60 now it should work let's
see yeah now we have now zero cyer so I'm assuming of course everything else is correct right
being non zero doesn't mean that I did everything correctly but currently it looks like it's correct so this is how
you encrypt it again this two I wrote by because I knew that I'm going I was planning to encrypt two blocks but maybe
you can give it as an input to the encryption function like here so my
previous thing but you know we call it I set size
of PL Tex divided by 16 right
so let's say that this is
in blocks let's say let's run it for blocks
okay it should be to M so let me check if I'm thinking correctly yes and the result is also the
same okay so I'm trying to parameterize it so if you in the future want to include four blocks I mean I don't want
you to write four here by hand you know it should work correct okay so we also
done this part so this part probably for the cases where it is not the size of the block so you know in the past we
talk about padding and Etc so at this point we don't need it but again this is
kind of the uh domain separation parameter if something if you're going to encrypt something that is not a
multiple of 128 bits then you should follow this line but if it is multiple
of this then you know you should follow this line this is what I understand from this picture
actually okay so let's see what is yeah I think L is that right I'm just
assuming but let's see it should be explained some place here but you can also check it
afterwards let me see if I can see the value L inside
the
text yes this is the P part as we can see
right yes this is where it explains if the final part is not divisible by this
then it follows the padding Etc okay so I'm not going into detail for that
so let's go back to our picture because we have one thing left that is the creation of the tag the finalization
part right so we need to do this so let's do
this now we have done the encryption I
to simplify if I do this everything will fit on the
screen correct right a little bit now I will do
finalization so finalization also needs the
input as our internal States nothing nothing else
right so I will say okay yeah okay so what I'm going to
do is and maybe I should also write the tag as an array
here P let's say which is 128 bits I will initialize it to
02 and I will send the the parameter to this function so
our finalization function should take to input
but actually we will also exor the key so I think I will also F the key but let me write this first so
64 65 right then it's
64 t two okay so what I was trying to tell it
it starts with exing with the key right so top 120 8 Bits nothing happens there
but the below 109 to2 bits first 128 bits is exort with the key so maybe I
should pass the key as a parameter pass by reference right key okay I will also
say it's 64
key so but it says that first exor X2
which ke zero and exort
X3 T1 okay so this is our first
step then it says perform ASCO permutation 12 times this is the same as
the initialization part so I will simply go to initialization part and copy past
this line okay simply write it here then I go back
to picture and it says that last two rows exort with the key again and
produce as the tag so this tells me that actually take
zero is X3 exort with
t0 okay let me of it F this and tag one
is the bottom row X4 exort with the key
now I will do the same thing as I print the cipher text now I will print the
uh tag since we do the pation let's say tag
take it just one8 FS so it be this let's see if the
compile yeah no errors for the compile and this is the results okay
this is the cipher text and this is the T so again since I don't have any Fest
vectors maybe I did an error and I don't didn't notice it so maybe since we're
recording afterwards we can watch the video and say that okay there was a mistake there okay but important thing
here the declarated programming actually allows me to you know uh think in a
clear way to what to do so for instance I start saying that I will call the initialization function actually at that
point I didn't have it but then you know I went up and implemented and follow the
steps during the uh implementation phase I'm trying to show this if you do it
like this okay actually the code becomes very
simple as you can see we are at the line 67 when I give an homework to students
to implement a cryptographic algorithm generally I receive thousands of lines of quotes but now I implemented an this
standards with just 67 I can also you know raise this line 66 lines of code of
course you can you know put this in a single line I just voted to see show it in a clearer
way so let me you know by the way if you have observed any mistakes I did just
let me know but I was just following this picture and I think I haven't
forgotten anything but what my implementation is missing the associated data and it actually doesn't check if I
need to do this padding or not it simply assumes that's you know my blocks are
direct T and you know produce as the output
okay so I think this concludes our
implementation okay I stopped it



### High-Level Context

- The speaker is implementing the **Ascon-based ASCON AEAD algorithm**, specifically the variant chosen by NIST for standardization: **ASCON AEA 128**.
- ASCON was the winner of the NIST Lightweight Cryptography Competition, and as of the transcript’s date, an initial public draft of the standard was released. The final specification may still change.
- ASCON is a family of authenticated encryption and hashing algorithms designed for constrained environments. The implementation shown focuses on the authenticated encryption variant (AEAD).

---

### Key Algorithmic Details

1. **State Size and Structure**:
   - ASCON state consists of 5 lanes (or “rows”), each 64 bits, so total state size is 320 bits.
   - The algorithm uses a permutation (often called `P`) that is applied multiple times. For initialization, 12 rounds are applied; during encryption, 6 or 8 rounds may be used depending on the mode. The transcript shows a variant with 12 rounds in the initialization phase and fewer rounds during processing.

2. **Rate and Capacity**:
   - The chosen variant (ASCON AEA 128) uses a rate of 128 bits and a capacity of 192 bits.
   - "Rate" is how many bits are absorbed or squeezed per permutation call during encryption and decryption.
   - "Capacity" is the remainder of the state that provides security (not directly exposed as plaintext/ciphertext during operations).

3. **Initial State Setup**:
   - The initial state is formed by concatenating:
     - A fixed 64-bit IV (Initialization Vector) defined by the standard.
     - The 128-bit key.
     - A 128-bit nonce.
   - After loading these into the state (X0 through X4), the permutation is applied 12 times.

4. **Initialization and Domain Separation**:
   - After the initial 12 rounds of permutation, the key is XORed again into parts of the state. This step creates a unique domain separation so that the subsequent operations on associated data (AD) and plaintext are treated distinctly.

5. **Associated Data (AD)**:
   - The standard supports adding AD (which is authenticated but not encrypted). The transcript’s final code does not handle AD, but the standard’s approach is similar: absorb AD blocks, apply permutations, and domain-separate before plaintext absorption.
   
6. **Plaintext Encryption**:
   - Plaintext is XORed into the rate portion of the state to produce ciphertext.
   - After XORing the plaintext, the state is permuted again a certain number of times (often 6 or 8, depending on the mode) before processing the next block.
   - The ciphertext is taken from the same portion of the state that the plaintext was XORed into, making it a “cover/uncover” sponge-like process.

7. **Finalization and Tag Computation**:
   - After all plaintext blocks are processed, finalization occurs.
   - The key is XORed into the state again, followed by another round of permutation operations.
   - Finally, the last two lanes of the state (128 bits) are XORed with the key again to produce the authentication tag.
   - The tag ensures integrity and authenticity of the ciphertext and the associated data.

---

### The Code Structure in the Transcript

1. **Declarative Programming Style**:
   - The presenter uses a top-down approach:
     - Write `main()` first, call functions like `initialization()`, `encryption()`, and `finalization()` before they are defined.
     - Later, implement these functions in detail, so the flow is logically clear from the start.

2. **Types and Variables**:
   - Uses `unsigned long long` or `uint64_t` (called `B_64` in the code) for 64-bit lane representation.
   - Maintains the state as `B_64 x[5];` representing the 5 x 64-bit lanes.

3. **Permutation (P) Implementation**:
   - The permutation step `P` consists of:
     - **Add round constant**: XOR a round-dependent constant into part of the state (usually lane x2).
     - **Substitution layer (S-box)**: A 5-bit S-box is applied bitwise across the state. By applying Boolean expressions directly to entire 64-bit words, the code performs 64 parallel S-box operations at once.
     - **Linear diffusion layer**: Each lane is combined with rotated versions of itself to spread (diffuse) differences throughout the state.

   The transcript shows copying the S-box logic from the original ASCON submission documents rather than manually extracting bits.

4. **Initialization Function**:
   - Loads IV, key, and nonce into `x0`, `x1`, `x2`, `x3`, and `x4`.
   - Runs the permutation with 12 rounds.
   - Then XORs part of the key back into the state for domain separation.

5. **Encryption Function**:
   - Assumes a known length of plaintext divided into 128-bit blocks.
   - For each block:
     - XOR plaintext into the rate portion of the state (x0 and x1).
     - Output that XORed value as ciphertext.
     - Apply permutation (8 rounds often mentioned in the standard).
   - If the plaintext length isn't a multiple of 128 bits, padding is needed, but the code in the transcript doesn’t implement this.

6. **Finalization Function**:
   - XOR key into the state.
   - Apply the permutation 12 times again.
   - XOR key again and output the tag from the lower lanes of the state.

---

### Testing and Verification

- The speaker prints intermediate states to ensure the code runs and doesn’t crash.
- Without official test vectors from the final standard or comparison to reference implementations, correctness verification is tentative at this stage.
- The final displayed ciphertext and tag are placeholders, as no official checks were done. Still, the logic aligns with the ASCON specification steps.

---

### What’s Missing or Simplified?

- **Associated Data (AD) Processing**: Not implemented, but would follow similar steps: absorb AD into the state, permute, and domain-separate.
- **Padding for Partial Blocks**: The transcript assumes full blocks. Real implementation must handle partial blocks by padding.
- **Official Test Vectors**: The final standard might provide test vectors for validation. Until then, confidence in correctness is limited.

---

### Key Takeaways

- The ASCON algorithm has a very clean and structured design, making it relatively straightforward to implement once you understand the permutation and the order of operations (initialize, absorb AD, encrypt plaintext, finalize).
- Implementing the S-box as Boolean functions over 64-bit words is a clever trick that avoids looping over each bit individually.
- Domain separation is crucial. XORing key material at different steps ensures that different phases of the algorithm (initialization, associated data, plaintext) remain cryptographically independent.

---