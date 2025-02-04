FasdUAS 1.101.10   ��   ��    k             l      ��  ��   
 *
 * Store v3.55 (21st May 2014) by Andy Davison.
 *
 *	Checks the user's group allocation and opens their server store, or asks the server to create one if none exists.
 *	Utilises the 'storefor.sh' script running on the Xserve and the '.store_template' directory.
 *
      � 	 	  
   * 
   *   S t o r e   v 3 . 5 5   ( 2 1 s t   M a y   2 0 1 4 )   b y   A n d y   D a v i s o n . 
   * 
   * 	 C h e c k s   t h e   u s e r ' s   g r o u p   a l l o c a t i o n   a n d   o p e n s   t h e i r   s e r v e r   s t o r e ,   o r   a s k s   t h e   s e r v e r   t o   c r e a t e   o n e   i f   n o n e   e x i s t s . 
   * 	 U t i l i s e s   t h e   ' s t o r e f o r . s h '   s c r i p t   r u n n i n g   o n   t h e   X s e r v e   a n d   t h e   ' . s t o r e _ t e m p l a t e '   d i r e c t o r y . 
   * 
     
  
 l     ��������  ��  ��        l     ��������  ��  ��        l     ��  ��    
  AFP     �      A F P      l     ����  r         m        �    a f p  o      ���� 0 protocol PROTOCOL��  ��        l    ����  r        m       �     > G o v e r n o r . _ a f p o v e r t c p . _ t c p . l o c a l  o      ���� 0 server SERVER��  ��     ! " ! l     ��������  ��  ��   "  # $ # l     �� % &��   % 
  SMB    & � ' '    S M B $  ( ) ( l     �� * +��   *  set PROTOCOL to "smb"    + � , , * s e t   P R O T O C O L   t o   " s m b " )  - . - l     �� / 0��   / . (set SERVER to "Governor._smb._tcp.local"    0 � 1 1 P s e t   S E R V E R   t o   " G o v e r n o r . _ s m b . _ t c p . l o c a l " .  2 3 2 l     ��������  ��  ��   3  4 5 4 l    6���� 6 r     7 8 7 m    	 9 9 � : :  G o v e r n o r 8 o      ���� 0 
servername 
SERVERNAME��  ��   5  ; < ; l    =���� = r     > ? > m     @ @ � A A   g o v e r n o r . s t u d i o s ? o      ���� 0 
httpserver 
HTTPSERVER��  ��   <  B C B l    D���� D r     E F E m     G G � H H  S t o r e s F o      ���� 0 
storeshare 
STORESHARE��  ��   C  I J I l     ��������  ��  ��   J  K L K l     �� M N��   M 0 * Gather ourselves some tasty user details.    N � O O T   G a t h e r   o u r s e l v e s   s o m e   t a s t y   u s e r   d e t a i l s . L  P Q P l    R���� R r     S T S l    U���� U I   �� V��
�� .sysoexecTEXT���     TEXT V m     W W � X X  e c h o   $ U S E R��  ��  ��   T o      ���� 0 ouruser OURUSER��  ��   Q  Y Z Y l   # [���� [ r    # \ ] \ l   ! ^���� ^ I   !�� _��
�� .sysoexecTEXT���     TEXT _ m     ` ` � a a  i d   - G n��  ��  ��   ] o      ���� 0 	ourgroups 	OURGROUPS��  ��   Z  b c b l  $ - d���� d r   $ - e f e l  $ ) g���� g I  $ )�� h��
�� .sysoexecTEXT���     TEXT h m   $ % i i � j j  l s   - 1   / V o l u m e s /��  ��  ��   f o      ���� 0 volumes VOLUMES��  ��   c  k l k l  . 5 m���� m r   . 5 n o n m   . 1 p p � q q  U n k n o w n o o      ���� 0 	storetype 	STORETYPE��  ��   l  r s r l  6 m t���� t Z   6 m u v w�� u E   6 ; x y x l  6 7 z���� z o   6 7���� 0 	ourgroups 	OURGROUPS��  ��   y m   7 : { { � | | , h u m - a h c - e a s - u n d e r g r a d s v r   > E } ~ } m   > A   � � �  U n d e r g r a d u a t e s ~ o      ���� 0 	storetype 	STORETYPE w  � � � E   H M � � � l  H I ����� � o   H I���� 0 	ourgroups 	OURGROUPS��  ��   � m   I L � � � � � * h u m - a h c - e a s - p o s t g r a d s �  � � � r   P W � � � m   P S � � � � �  P o s t g r a d u a t e s � o      ���� 0 	storetype 	STORETYPE �  � � � E   Z _ � � � l  Z [ ����� � o   Z [���� 0 	ourgroups 	OURGROUPS��  ��   � m   [ ^ � � � � � * h u m - a h c - e a s - a c a d e m i c s �  ��� � r   b i � � � m   b e � � � � �  A c a d e m i c s � o      ���� 0 	storetype 	STORETYPE��  ��  ��  ��   s  � � � l     ��������  ��  ��   �  � � � l  n { ����� � r   n { � � � l  n w ����� � b   n w � � � b   n u � � � o   n q���� 0 	storetype 	STORETYPE � m   q t � � � � �  : � o   u v���� 0 ouruser OURUSER��  ��   � o      ���� 0 	storepath 	STOREPATH��  ��   �  � � � l  | � ����� � r   | � � � � m   |  � � � � �  N o � o      ���� 0 
storeready 
STOREREADY��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �   Do appropriate things.    � � � � .   D o   a p p r o p r i a t e   t h i n g s . �  � � � l  �< ����� � Z   �< � ��� � � >  � � � � � l  � � ����� � o   � ����� 0 	storetype 	STORETYPE��  ��   � m   � � � � � � �  U n k n o w n � k   �� � �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � + % Mount the share if it isn't already.    � � � � J   M o u n t   t h e   s h a r e   i f   i t   i s n ' t   a l r e a d y . �  � � � Z   �$ � ����� � H   � � � � E   � � � � � l  � � ����� � o   � ����� 0 volumes VOLUMES��  ��   � m   � � � � � � �  S t o r e s � k   �  � �  � � � l  � ���������  ��  ��   �  � � � r   � � � � � l  � � ����� � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � ����� 0 protocol PROTOCOL � m   � � � � � � �  : / / � o   � ����� 0 server SERVER � m   � � � � � � �  / � o   � ����� 0 
storeshare 
STORESHARE��  ��   � o      ���� "0 serverstorepath SERVERSTOREPATH �  � � � l  � ���������  ��  ��   �  � � � O   � � � � k   � � �  � � � l  � ���������  ��  ��   �  � � � Q   � � � � � I  � ��� ���
�� .aevtmvolnull���     TEXT � o   � ����� "0 serverstorepath SERVERSTOREPATH��   � R      ����~
�� .ascrerr ****      � ****�  �~   � Q   � � � � � I  � ��} ��|
�} .aevtmvolnull���     TEXT � o   � ��{�{ "0 serverstorepath SERVERSTOREPATH�|   � R      �z�y�x
�z .ascrerr ****      � ****�y  �x   � k   � � �  � � � I  ��w � �
�w .sysodlogaskr        TEXT � b   � � �  � b   � � b   � � b   � � b   � � b   � �	
	 b   � � o   � ��v
�v 
ret  m   � � � n A t t e m p t s   t o   c o n n e c t   t o   t h e   S t o r e   s y s t e m   h a v e n ' t   w o r k e d .
 o   � ��u
�u 
ret  o   � ��t
�t 
ret  l 	 � ��s�r m   � � � | I f   t h i s   p r o b l e m   p e r s i s t s ,   p l e a s e   c o n t a c t   t h e   M u s i c   T e c h n i c i a n .�s  �r   o   � ��q
�q 
ret  o   � ��p
�p 
ret   o   � ��o�o "0 serverstorepath SERVERSTOREPATH � �n
�n 
btns v   � � �m m   � � �  O K�m   �l
�l 
givu m   ��k�k 
 �j
�j 
disp m  �i�i  �h�g
�h 
appr m  	 � " U n a b l e   t o   C o n n e c t�g   � �f L  �e�e  �f   �  �d  l �c�b�a�c  �b  �a  �d   � m   � �!!�                                                                                  MACS  alis    l  	Macintosh                  �qy�H+   	�
Finder.app                                                      
�@ζ�h        ����  	                CoreServices    �qk�      ζ�h     	� 	��   l  3Macintosh:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 M a c i n t o s h  &System/Library/CoreServices/Finder.app  / ��   � "#" l �`�_�^�`  �_  �^  # $%$ I �]&�\
�] .sysodelanull��� ��� nmbr& m  �[�[ �\  % '�Z' l �Y�X�W�Y  �X  �W  �Z  ��  ��   � ()( l %%�V�U�T�V  �U  �T  ) *+* l %%�S,-�S  , 0 * See if the user's Store actually exists.	   - �.. T   S e e   i f   t h e   u s e r ' s   S t o r e   a c t u a l l y   e x i s t s . 	+ /0/ O  %K121 Z  +J34�R�Q3 l +<5�P�O5 I +<�N6�M
�N .coredoexbool        obj 6 n  +8787 4  18�L9
�L 
cfol9 o  47�K�K 0 	storepath 	STOREPATH8 4  +1�J:
�J 
cdis: o  /0�I�I 0 
storeshare 
STORESHARE�M  �P  �O  4 r  ?F;<; m  ?B== �>>  Y e s< o      �H�H 0 
storeready 
STOREREADY�R  �Q  2 m  %(??�                                                                                  MACS  alis    l  	Macintosh                  �qy�H+   	�
Finder.app                                                      
�@ζ�h        ����  	                CoreServices    �qk�      ζ�h     	� 	��   l  3Macintosh:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 M a c i n t o s h  &System/Library/CoreServices/Finder.app  / ��  0 @A@ l LL�G�F�E�G  �F  �E  A BCB l LL�DDE�D  D   Create it, if needs be.   E �FF 0   C r e a t e   i t ,   i f   n e e d s   b e .C GHG Z  LqIJ�C�BI = LSKLK l LOM�A�@M o  LO�?�? 0 
storeready 
STOREREADY�A  �@  L m  ORNN �OO  N oJ k  VmPP QRQ l VV�>�=�<�>  �=  �<  R STS l VV�;UV�;  U $  Magic server-side generation.   V �WW <   M a g i c   s e r v e r - s i d e   g e n e r a t i o n .T XYX Q  V�Z[\Z I Yt�:]�9
�: .sysoexecTEXT���     TEXT] b  Yp^_^ b  Yl`a` b  Yhbcb b  Ydded b  Ybfgf b  Y^hih m  Y\jj �kk  c u r l   ' h t t p : / /i o  \]�8�8 0 
httpserver 
HTTPSERVERg m  ^all �mm 4 / s y s t e m / s t o r e f o r . p h p ? u s e r =e o  bc�7�7 0 ouruser OURUSERc m  dgnn �oo  & g r o u p =a o  hk�6�6 0 	storetype 	STORETYPE_ m  lopp �qq  '�9  [ R      �5�4�3
�5 .ascrerr ****      � ****�4  �3  \ k  |�rr sts I |��2uv
�2 .sysodlogaskr        TEXTu b  |�wxw b  |�yzy b  |�{|{ b  |�}~} b  |�� b  |���� b  |���� b  |���� b  |���� o  |�1
�1 
ret � m  ��� ��� 8 C r e a t i o n   r e q u e s t   h a s   f a i l e d .� o  ���0
�0 
ret � o  ���/
�/ 
ret � l 	����.�-� m  ���� ��� | I f   t h i s   p r o b l e m   p e r s i s t s ,   p l e a s e   c o n t a c t   t h e   M u s i c   T e c h n i c i a n .�.  �-  � o  ���,
�, 
ret ~ o  ���+
�+ 
ret | m  ���� ��� " U n a b l e   t o   r e a c h   'z o  ���*�* 0 
httpserver 
HTTPSERVERx m  ���� ���  ' .v �)��
�) 
btns� v  ���� ��(� m  ���� ���  O K�(  � �'��
�' 
givu� m  ���&�& 
� �%��
�% 
disp� m  ���$�$ � �#��"
�# 
appr� m  ���� ��� " U n a b l e   t o   C o n n e c t�"  t ��!� L  ��� �   �!  Y ��� l ������  �  �  � ��� I �����
� .sysodlogaskr        TEXT� b  ����� b  ����� b  ����� b  ����� o  ���
� 
ret � m  ���� ��� 8 Y o u r   S t o r e   i s   b e i n g   c r e a t e d .� o  ���
� 
ret � o  ���
� 
ret � l 	������ m  ���� ��� � T h i s   i s   u s u a l l y   o n l y   t a k e s   a   f e w   m o m e n t s   a n d   w i l l   o p e n   a u t o m a t i c a l l y   o n c e   c o m p l e t e .�  �  � ���
� 
btns� v  ���� ��� m  ���� ���  O K�  � ���
� 
givu� m  ���� 
� ���
� 
disp� m  ���� � ���
� 
appr� m  ���� ���   G e n e r a t i n g   S t o r e�  � ��� l ������  �  �  � ��� I �����

� .sysodelanull��� ��� nmbr� m  ���	�	 �
  � ��� l ������  �  �  � ��� l ������  � * $ Damn it, Finder - update, will you!   � ��� H   D a m n   i t ,   F i n d e r   -   u p d a t e ,   w i l l   y o u !� ��� I ����
� .sysoexecTEXT���     TEXT� b  ���� b  �
��� b  ���� b  ���� m  � �� ���  l s   / V o l u m e s /� o   �� 0 
storeshare 
STORESHARE� m  �� ���  /� o  	�� 0 	storetype 	STORETYPE� m  
�� ���    & > / d e v / n u l l�  � ��� I (� ���
�  .sysoexecTEXT���     TEXT� b  $��� b   ��� b  ��� b  ��� m  �� ���  l s   / V o l u m e s /� o  ���� 0 
storeshare 
STORESHARE� m  �� ���  /� o  ���� 0 	storetype 	STORETYPE� m   #�� ���    & > / d e v / n u l l��  � ��� I )>�����
�� .sysoexecTEXT���     TEXT� b  ):��� b  )6��� b  )2��� b  ).��� m  ),�� ���  l s   / V o l u m e s /� o  ,-���� 0 
storeshare 
STORESHARE� m  .1�� ���  /� o  25���� 0 	storetype 	STORETYPE� m  69�� ���    & > / d e v / n u l l��  � � � l ??��������  ��  ��     I ?D����
�� .sysodelanull��� ��� nmbr m  ?@���� ��    l EE��������  ��  ��    O  Ek	 Z  Kj
����
 l K\���� I K\����
�� .coredoexbool        obj  n  KX 4  QX��
�� 
cfol o  TW���� 0 	storepath 	STOREPATH 4  KQ��
�� 
cdis o  OP���� 0 
storeshare 
STORESHARE��  ��  ��   r  _f m  _b �  Y e s o      ���� 0 
storeready 
STOREREADY��  ��  	 m  EH�                                                                                  MACS  alis    l  	Macintosh                  �qy�H+   	�
Finder.app                                                      
�@ζ�h        ����  	                CoreServices    �qk�      ζ�h     	� 	��   l  3Macintosh:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 M a c i n t o s h  &System/Library/CoreServices/Finder.app  / ��   �� l ll��������  ��  ��  ��  �C  �B  H  l rr��������  ��  ��    Z  r��� = ry  l ru!����! o  ru���� 0 
storeready 
STOREREADY��  ��    m  ux"" �##  Y e s k  |�$$ %&% l ||��������  ��  ��  & '(' O  |�)*) k  ��++ ,-, I ��������
�� .miscactvnull��� ��� obj ��  ��  - .��. I ������/
�� .corecrel****      � null��  / ��01
�� 
kocl0 m  ����
�� 
brow1 ��2��
�� 
to  2 n  ��343 4  ����5
�� 
cfol5 o  ������ 0 	storepath 	STOREPATH4 4  ����6
�� 
cdis6 o  ������ 0 
storeshare 
STORESHARE��  ��  * m  |77�                                                                                  MACS  alis    l  	Macintosh                  �qy�H+   	�
Finder.app                                                      
�@ζ�h        ����  	                CoreServices    �qk�      ζ�h     	� 	��   l  3Macintosh:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 M a c i n t o s h  &System/Library/CoreServices/Finder.app  / ��  ( 8��8 l ����������  ��  ��  ��  ��   k  ��99 :;: l ����������  ��  ��  ; <=< I ����>?
�� .sysodlogaskr        TEXT> b  ��@A@ b  ��BCB b  ��DED b  ��FGF o  ����
�� 
ret G m  ��HH �II < Y o u r   S t o r e   i s   n o t   q u i t e   r e a d y .E o  ����
�� 
ret C o  ����
�� 
ret A l 	��J����J m  ��KK �LL � P l e a s e   t r y   a g a i n   i n   a   f e w   m o m e n t s   b y   c l i c k i n g   o n   t h e   S t o r e   i c o n   o n   t h e   D o c k   ( s e c o n d   i c o n   f r o m   t h e   l e f t ) .��  ��  ? ��MN
�� 
btnsM v  ��OO P��P m  ��QQ �RR  O K��  N ��ST
�� 
givuS m  ������ 
T ��UV
�� 
dispU m  ������ V ��W��
�� 
apprW m  ��XX �YY   G e n e r a t i n g   S t o r e��  = Z��Z l ����������  ��  ��  ��   [��[ l ����������  ��  ��  ��  ��   � k  �<\\ ]^] l ����������  ��  ��  ^ _`_ Z  �:ab����a F  � cdc F  ��efe > ��ghg l ��i����i o  ������ 0 ouruser OURUSER��  ��  h m  ��jj �kk 
 a d m i nf > ��lml l ��n����n o  ������ 0 ouruser OURUSER��  ��  m m  ��oo �pp 
 g u e s td > ��qrq l ��s����s o  ������ 0 ouruser OURUSER��  ��  r m  ��tt �uu  v i s i t o rb k  6vv wxw l ��������  ��  ��  x yzy I 4��{|
�� .sysodlogaskr        TEXT{ b  }~} b  � b  ��� b  
��� o  ��
�� 
ret � m  	�� ��� � Y o u r   a c c o u n t   i s   n o t   i n   a   g r o u p   t h a t   h a s   s t o r a g e   s p a c e   o n   o u r   s e r v e r .� o  
��
�� 
ret � o  ��
�� 
ret ~ l 	������ m  �� ��� � P l e a s e   c o n t a c t   t h e   M u s i c   T e c h n i c i a n   i f   y o u   b e l i e v e   y o u   s h o u l d   h a v e   a   S t o r e   s p a c e   o n   t h e s e   s y s t e m s .��  ��  | ����
�� 
btns� v  �� ���� m  �� ���  O K��  � ����
�� 
givu� m  !$���� 
� ����
�� 
disp� m  '(���� � �����
�� 
appr� m  +.�� ��� $ N o   S t o r e   A v a i l a b l e��  z ���� l 55��������  ��  ��  ��  ��  ��  ` ���� l ;;��������  ��  ��  ��  ��  ��   � ��� l     ��������  ��  ��  � ��� l     �������  ��  �  � ��� l     �~�}�|�~  �}  �|  � ��� l     �{�z�y�{  �z  �y  � ��� l     �x�w�v�x  �w  �v  � ��u� l     �t�s�r�t  �s  �r  �u       �q��   9 @ G��� ��=��p�o�n�q  � �m�l�k�j�i�h�g�f�e�d�c�b�a�`�_�^
�m .aevtoappnull  �   � ****�l 0 protocol PROTOCOL�k 0 server SERVER�j 0 
servername 
SERVERNAME�i 0 
httpserver 
HTTPSERVER�h 0 
storeshare 
STORESHARE�g 0 ouruser OURUSER�f 0 	ourgroups 	OURGROUPS�e 0 volumes VOLUMES�d 0 	storetype 	STORETYPE�c 0 	storepath 	STOREPATH�b 0 
storeready 
STOREREADY�a "0 serverstorepath SERVERSTOREPATH�`  �_  �^  � �]��\�[���Z
�] .aevtoappnull  �   � ****� k    <��  ��  ��  4��  ;��  B��  P��  Y��  b��  k��  r��  ���  ���  ��Y�Y  �\  �[  �  � c �X �W 9�V @�U G�T W�S�R `�Q i�P p�O {  � � � � ��N ��M � � � ��L!�K�J�I�H�G�F�E�D�C�B�A�@�?�>�==Njlnp�������������������"�<�;�:�9�8�7HKQXjo�6t�����X 0 protocol PROTOCOL�W 0 server SERVER�V 0 
servername 
SERVERNAME�U 0 
httpserver 
HTTPSERVER�T 0 
storeshare 
STORESHARE
�S .sysoexecTEXT���     TEXT�R 0 ouruser OURUSER�Q 0 	ourgroups 	OURGROUPS�P 0 volumes VOLUMES�O 0 	storetype 	STORETYPE�N 0 	storepath 	STOREPATH�M 0 
storeready 
STOREREADY�L "0 serverstorepath SERVERSTOREPATH
�K .aevtmvolnull���     TEXT�J  �I  
�H 
ret 
�G 
btns
�F 
givu�E 

�D 
disp
�C 
appr�B 
�A .sysodlogaskr        TEXT
�@ .sysodelanull��� ��� nmbr
�? 
cdis
�> 
cfol
�= .coredoexbool        obj 
�< .miscactvnull��� ��� obj 
�; 
kocl
�: 
brow
�9 
to  �8 
�7 .corecrel****      � null
�6 
bool�Z=�E�O�E�O�E�O�E�O�E�O�j E�O�j E�O�j E` Oa E` O�a  a E` Y '�a  a E` Y �a  a E` Y hO_ a %�%E` Oa E` O_ a W_ a  ��a %�%a  %�%E` !Oa " h _ !j #W YX $ % _ !j #W GX $ %_ &a '%_ &%_ &%a (%_ &%_ &%_ !%a )a *ka +a ,a -la .a /a 0 1OhOPUOmj 2OPY hOa " !*a 3�/a 4_ /j 5 a 6E` Y hUO_ a 7   a 8�%a 9%�%a :%_ %a ;%j W MX $ %_ &a <%_ &%_ &%a =%_ &%_ &%a >%�%a ?%a )a @ka +a ,a -la .a Aa 0 1OhO_ &a B%_ &%_ &%a C%a )a Dka +a ,a -ka .a Ea 0 1Oa 0j 2Oa F�%a G%_ %a H%j Oa I�%a J%_ %a K%j Oa L�%a M%_ %a N%j Olj 2Oa " !*a 3�/a 4_ /j 5 a OE` Y hUOPY hO_ a P  1a " %*j QO*a Ra Sa T*a 3�/a 4_ /a U VUOPY 5_ &a W%_ &%_ &%a X%a )a Yka +a ,a -ka .a Za 0 1OPOPY [�a [	 �a \a ]&	 �a ^a ]& 8_ &a _%_ &%_ &%a `%a )a aka +a ,a -la .a ba 0 1OPY hOP� ���  m f t s s a d 4� ���� D S \ D o m a i n   U s e r s   D S \ U R S U s e r s   D S \ h u m - a h c - r o l e - m u s i c t e c h n i c i a n   D S \ h u m - S A L C - s t u d - s u p - g u i d   D S \ h u m - a h c - r o l e - d r a m a t e c h   D S \ H U M _ a h c _ A D _ A d m i n   D S \ h u m - a l c - a l l - s t a f f   D S \ h u m - a h c - M H C e v e n t s - c a l e n d a r   D S \ h u m - a h c - m h - g 3 1 s h a r p - p r i n t   e v e r y o n e   n e t a c c o u n t s   D S \ a d m i n - r s d - a u t h o r i s e d   s i g n a t u r e s   D S \ h u m - a h c - e a s - a c a d e m i c s   D S \ h u m - a h c - d e p t d a t a   e a s _ a l l u s e r s   D S \ S H _ m c c s o f t _ F S _ R e a d _ A c c e s s   e a s _ a c a d e m i c s� ���   M a c i n t o s h  S h a r e d� ��� $ A c a d e m i c s : m f t s s a d 4� ��� X a f p : / / G o v e r n o r . _ a f p o v e r t c p . _ t c p . l o c a l / S t o r e s�p  �o  �n   ascr  ��ޭ