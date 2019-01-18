open Array;;

type location = | A | B | AB ;;
 
let compare_x (a,_) (b,_) = a - b;; (*assume tuples are int, easily generalizes to floats*)

let max_x a = let rec helper l i j m = match l with | [] -> j (* find max of array *)
													| h::tl -> if (compare_x h m > 0) then helper tl (i+1) i h else helper tl (i+1) j m
			in helper a 0 0 (List.hd a);;

let split lst n =
	let rec helper first second i = match second with 	| [] -> (List.rev first, [])
														| h::t -> 	if i = 0 then (List.rev first, second)
																	else helper (h::first) t (i-1) in
									helper [] lst n;;

let y p1 p2 v = let (x1,y1) = p1 and (x2,y2) = p2 in (*assumes tuples are ints*)
				let x1 = float_of_int x1 and x2 = float_of_int x2 and y1 = float_of_int y1 and y2 = float_of_int y2 in
				(y2 -. y1) *. (v -. x1) /. (x2 -. x1) +. y1;;

let cw a b i j p q v = (y (get a i) (get b ((j+1) mod q)) v, y (get a ((i+1) mod p)) (get b j) v, (y (get a i) (get b j)) v);;

let ccw a b i j p q v = (y (get a i) (get b ((j+q-1) mod q)) v, y (get a ((i+p-1) mod p)) (get b j) v, (y (get a i) (get b j)) v);;

let upperTangent a b init p q v =	let rec helper i j = let (r,l,m) = cw a b i j p q v in  
					if (r > m || l > m) then (if r > m then helper i ((j+1) mod q) else helper ((i+1) mod p) j) else (i, j)
	in helper init 0;;

let lowerTangent a b init p q v = 	let rec helper i j = let (r,l,m) = ccw a b i j p q v in 
					if (r < m || l < m) then (if r < m then helper i ((j+q-1) mod q) else helper ((i+p-1) mod p) j) else (i, j)
	in helper init 0;;

let merge a b = match b with 	| [] -> a
								| _ -> 	let p1 = Array.of_list a and p2 = Array.of_list b and p = List.length a and q = List.length b and m = max_x a in
										let (a0,_) = get p1 m and (b0,_) =  get p2 0 in 
										let l = (float_of_int (a0 + b0)) /. 2. in
										let (x1,x2) = upperTangent p1 p2 m p q l and (y1,y2) = lowerTangent p1 p2 m p q l in 
										let rec helper pt hull loc = 
											if (loc == A || loc == B) then (if loc == A 
																				then 
																					(if pt == x1 then helper x2 ((get p1 x1)::hull) B else helper ((pt + 1) mod p) ((get p1 pt)::hull) A)
																				else 
																					(if pt == y2 then helper y1 ((get p2 pt)::hull) AB else helper ((pt + 1) mod q) ((get p2 pt)::hull) B)
																			) 
											else(if pt == x1 || pt == 0	then (* been in A and B *)
																	List.rev hull 
																else 
																	helper ((pt + 1) mod p) ((get p1 pt)::hull) AB
												)
				 						in helper 0 [] A;;

(* Divide and conquer approach - O(nlogn) *)														

let convexHull pts = let rec helper p n = 	let r = n/2 in 
											if n > 2 then (let (a,b) = split p r in 
											merge (helper a r) (helper b (n-r))) else p
	in helper (List.sort compare_x pts) (List.length pts);;


(*

let toTikz pts hull = 
	let rec helper1 pts str = match pts with | [] -> str
											| h::tl -> let (x,y) = h in helper1 tl (str ^ "\\node at (" ^ string_of_int x ^ "," ^ string_of_int y ^ ") () {};\n"

	and rec helper2 hull prev s str = match hull with 	| [] -> let (a,b) = prev and (x,y) = s in
																let a = string_of_int a and b = string_of_int b and x = string_of_int x and y = string_of_int y in
																helper2 tl h (str ^ "\\draw[dashed] (" ^ a ^ "," ^ b ^ ") -- (" ^ x ^ "," ^ y ^ ");") 
														| h::tl -> let (a,b) = prev and (x,y) = h in
																let a = string_of_int a and b = string_of_int b and x = string_of_int x and y = string_of_int y in
																helper2 tl h (str ^ "\\draw[dashed] (" ^ a ^ "," ^ b ^ ") -- (" ^ x ^ "," ^ y ^ ");")
	in (helper2 hull (List.hd hull) (List.hd hull) (helper 1 pts "\\begin{tikzpicture}\n")) ^ "\\end{tikzpicture}";;

let same_side x y pts = 
	let helper a b p isNonNeg = match p with 	| [] -> true
												| h::tl -> let (x1,y1) = a and (x2,y2) = b and (h1,h2) = h in 
												let v = (x2 - x1)*h2 + (y1-y2)*h1 - y1 in (* line through a b is y - y1 = (y2-y1)/(x2-x1)(x-x1) *)
												match isNonNeg with | Zero -> 	if v >= 0 then (if v == 0 then helper x y tl Zero else helper x y tl Pos)
												  								else helper x y tl Neg
																	| Pos -> 	if v >= 0 then helper x y tl Pos else false
																	| Neg -> 	if v <= 0 then helper x y tl Neg else false
	in helper x y pts Zero;;

*)