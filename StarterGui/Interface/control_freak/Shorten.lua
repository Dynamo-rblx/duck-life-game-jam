-- @ScriptType: ModuleScript
local v1 = {
	Comma = function(p1)
		local v2 = p1;
		while true do
			local v3, v4 = string.gsub(v2, "^(-?%d+)(%d%d%d)", "%1,%2");
			v2 = v3;
			if v4 == 0 then
				break;
			end;		
		end;
		return v2;
	end
};
function addComas(p2)
	return #p2 % 3 == 0 and p2:reverse():gsub("(%d%d%d)", "%1,"):reverse():sub(2) or p2:reverse():gsub("(%d%d%d)", "%1,"):reverse();
end;
local function u1(p3)
	return math.floor(p3 + 0.5);
end;
local function u2(p4)
	return math.floor(p4 * 10) * 0.1;
end;
function v1.Short(p5)
	if p5 < -1000 then
		p5 = u1(tonumber(p5));
		p5 = addComas(tostring(p5));
		return p5;
	end;
	if p5 < 0 and p5 >= -1000 then
		p5 = u2(tonumber(p5));
		return p5;
	end;
	if p5 < 1000 and p5 >= 0 then
		p5 = u2(tonumber(p5));
		return p5;
	end;
	if p5 < 1000000 and p5 >= 1000 then
		p5 = tostring(p5 / 1000):sub(1, 5) .. "K"; -- Thousand
		return p5;
	end;
	if p5 < 1000000000 and p5 >= 1000000 then
		p5 = tostring(p5 / 1000000):sub(1, 5) .. "M"; -- Million
		return p5;
	end;
	if p5 < 1000000000000 and p5 >= 1000000000 then
		p5 = tostring(p5 / 1000000000):sub(1, 5) .. "B"; -- Billion
		return p5;
	end;
	if p5 < 1000000000000000 and p5 >= 1000000000000 then
		p5 = tostring(p5 / 1000000000000):sub(1, 5) .. "T"; -- Trillion
		return p5;
	end;
	if p5 < 1E+18 and p5 >= 1000000000000000 then
		p5 = tostring(p5 / 1000000000000000):sub(1, 5) .. "Qd"; -- Quadrillion
		return p5;
	end;
	if p5 < 1E+21 and p5 >= 1E+18 then
		p5 = tostring(p5 / 1E+18):sub(1, 5) .. "Qn"; -- Quintillion
		return p5;
	end;
	if p5 < 1E+24 and p5 >= 1E+21 then
		p5 = tostring(p5 / 1E+21):sub(1, 5) .. "Sx"; -- Sextillion
		return p5;
	end;
	if p5 < 1E+27 and p5 >= 1E+24 then
		p5 = tostring(p5 / 1E+24):sub(1, 5) .. "Sp"; -- Septillion
		return p5;
	end;
	if p5 < 1E+30 and p5 >= 1E+27 then
		p5 = tostring(p5 / 1E+27):sub(1, 5) .. "Oc"; -- Octillion
		return p5;
	end;
	if p5 < 1E+33 and p5 >= 1E+30 then
		p5 = tostring(p5 / 1E+30):sub(1, 5) .. "No"; -- Nonillion
		return p5;
	end;
	if p5 < 1E+36 and p5 >= 1E+33 then
		p5 = tostring(p5 / 1E+33):sub(1, 5) .. "De"; -- Decillion
		return p5;
	end;
	if p5 < 1E+39 and p5 >= 1E+36 then
		p5 = tostring(p5 / 1E+36):sub(1, 5) .. "UD";
		return p5;
	end;
	if p5 < 1E+42 and p5 >= 1E+39 then
		p5 = tostring(p5 / 1E+39):sub(1, 5) .. "DD";
		return p5;
	end;
	if p5 < 1E+45 and p5 >= 1E+42 then
		p5 = tostring(p5 / 1E+42):sub(1, 5) .. "TdD";
		return p5;
	end;
	if p5 < 1E+48 and p5 >= 1E+45 then
		p5 = tostring(p5 / 1E+45):sub(1, 5) .. "QdD";
		return p5;
	end;
	if p5 < 1E+51 and p5 >= 1E+48 then
		p5 = tostring(p5 / 1E+48):sub(1, 5) .. "QnD";
		return p5;
	end;
	if p5 < 1E+54 and p5 >= 1E+51 then
		p5 = tostring(p5 / 1E+51):sub(1, 5) .. "SxD";
		return p5;
	end;
	if p5 < 1E+57 and p5 >= 1E+54 then
		p5 = tostring(p5 / 1E+54):sub(1, 5) .. "SpD";
		return p5;
	end;
	if p5 < 1E+60 and p5 >= 1E+57 then
		p5 = tostring(p5 / 1E+57):sub(1, 5) .. "OcD";
		return p5;
	end;
	if p5 < 1E+63 and p5 >= 1E+60 then
		p5 = tostring(p5 / 1E+60):sub(1, 5) .. "NoD";
		return p5;
	end;
	if p5 < 1E+66 and p5 >= 1E+63 then
		p5 = tostring(p5 / 1E+63):sub(1, 5) .. "Vg";
		return p5;
	end;
	if p5 < 1E+69 and p5 >= 1E+66 then
		p5 = tostring(p5 / 1E+66):sub(1, 5) .. "UVg";
		return p5;
	end;
	if p5 < 1E+72 and p5 >= 1E+69 then
		p5 = tostring(p5 / 1E+69):sub(1, 5) .. "DVg";
		return p5;
	end;
	if p5 < 1E+75 and p5 >= 1E+72 then
		p5 = tostring(p5 / 1E+72):sub(1, 5) .. "TVg";
		return p5;
	end;
	if p5 < 1E+78 and p5 >= 1E+75 then
		p5 = tostring(p5 / 1E+75):sub(1, 5) .. "QTVg";
		return p5;
	end;
	if p5 < 1E+81 and p5 >= 1E+78 then
		p5 = tostring(p5 / 1E+78):sub(1, 5) .. "QNVg";
		return p5;
	end;
	if p5 < 1E+84 and p5 >= 1E+81 then
		p5 = tostring(p5 / 1E+81):sub(1, 5) .. "SeVg";
		return p5;
	end;
	if p5 < 1E+87 and p5 >= 1E+84 then
		p5 = tostring(p5 / 1E+84):sub(1, 5) .. "SPVg";
		return p5;
	end;
	if p5 < 1E+90 and p5 >= 1E+87 then
		p5 = tostring(p5 / 1E+87):sub(1, 5) .. "OVg";
		return p5;
	end;
	if p5 < 1E+93 and p5 >= 1E+90 then
		p5 = tostring(p5 / 1E+90):sub(1, 5) .. "NVg";
		return p5;
	end;
	if p5 < 1E+96 and p5 >= 1E+93 then
		p5 = tostring(p5 / 1E+93):sub(1, 5) .. "TG";
		return p5;
	end;
	if p5 < 1E+99 and p5 >= 1E+96 then
		p5 = tostring(p5 / 1E+96):sub(1, 5) .. "UTg";
		return p5;
	end;
	if p5 < 1E+102 and p5 >= 1E+99 then
		p5 = tostring(p5 / 1E+99):sub(1, 5) .. "DTg";
		return p5;
	end;
	if p5 < 1E+105 and p5 >= 1E+102 then
		p5 = tostring(p5 / 1E+102):sub(1, 5) .. "TsTg";
		return p5;
	end;
	if p5 < 1E+108 and p5 >= 1E+105 then
		p5 = tostring(p5 / 1E+105):sub(1, 5) .. "QtTg";
		return p5;
	end;
	if p5 < 1E+111 and p5 >= 1E+108 then
		p5 = tostring(p5 / 1E+108):sub(1, 5) .. "QnTg";
		return p5;
	end;
	if p5 < 1E+114 and p5 >= 1E+111 then
		p5 = tostring(p5 / 1E+111):sub(1, 5) .. "SsTg";
		return p5;
	end;
	if p5 < 1E+117 and p5 >= 1E+114 then
		p5 = tostring(p5 / 1E+114):sub(1, 5) .. "SpTg";
		return p5;
	end;
	if p5 < 1E+120 and p5 >= 1E+117 then
		p5 = tostring(p5 / 1E+117):sub(1, 5) .. "OcTg";
		return p5;
	end;
	if p5 < 1E+123 and p5 >= 1E+120 then
		p5 = tostring(p5 / 1E+120):sub(1, 5) .. "NoTg";
		return p5;
	end;
	if p5 < 1E+126 and p5 >= 1E+123 then
		p5 = tostring(p5 / 1E+123):sub(1, 5) .. "QDR";
		return p5;
	end;
	if p5 < 1E+129 and p5 >= 1E+126 then
		p5 = tostring(p5 / 1E+126):sub(1, 5) .. "UQDR";
		return p5;
	end;
	if p5 < 1E+132 and p5 >= 1E+129 then
		p5 = tostring(p5 / 1E+129):sub(1, 5) .. "DQDR";
		return p5;
	end;
	if p5 < 1E+135 and p5 >= 1E+132 then
		p5 = tostring(p5 / 1E+132):sub(1, 5) .. "TQDR";
		return p5;
	end;
	if p5 < 1E+138 and p5 >= 1E+135 then
		p5 = tostring(p5 / 1E+135):sub(1, 5) .. "QdQDR";
		return p5;
	end;
	if p5 < 1E+141 and p5 >= 1E+138 then
		p5 = tostring(p5 / 1E+138):sub(1, 5) .. "QnQDR";
		return p5;
	end;
	if p5 < 1E+144 and p5 >= 1E+141 then
		p5 = tostring(p5 / 1E+141):sub(1, 5) .. "SxQDR";
		return p5;
	end;
	if p5 < 1E+147 and p5 >= 1E+144 then
		p5 = tostring(p5 / 1E+144):sub(1, 5) .. "SpQDR";
		return p5;
	end;
	if p5 < 1E+150 and p5 >= 1E+147 then
		p5 = tostring(p5 / 1E+147):sub(1, 5) .. "OQQDR";
		return p5;
	end;
	if p5 < 1E+153 and p5 >= 1E+150 then
		p5 = tostring(p5 / 1E+150):sub(1, 5) .. "NQDDR";
		return p5;
	end;
	if p5 < 1E+156 and p5 >= 1E+153 then
		p5 = tostring(p5 / 1E+153):sub(1, 5) .. "QQGNT";
		return p5;
	end;
	if p5 < 1E+159 and p5 >= 1E+156 then
		p5 = tostring(p5 / 1E+156):sub(1, 5) .. "UQGNT";
		return p5;
	end;
	if p5 < 1E+162 and p5 >= 1E+159 then
		p5 = tostring(p5 / 1E+159):sub(1, 5) .. "DQGNT";
		return p5;
	end;
	if p5 < 1E+165 and p5 >= 1E+162 then
		p5 = tostring(p5 / 1E+162):sub(1, 5) .. "TQGNT";
		return p5;
	end;
	if p5 < 1E+168 and p5 >= 1E+165 then
		p5 = tostring(p5 / 1E+165):sub(1, 5) .. "QQGNT";
		return p5;
	end;
	if p5 < 1E+171 and p5 >= 1E+168 then
		p5 = tostring(p5 / 1E+171):sub(1, 5) .. "QQGNT";
		return p5;
	end;
	if p5 < 1E+174 and p5 >= 1E+171 then
		p5 = tostring(p5 / 1E+174):sub(1, 5) .. "SXQGNT";
		return p5;
	end;
	if p5 < 1E+177 and p5 >= 1E+174 then
		p5 = tostring(p5 / 1E+177):sub(1, 5) .. "SPQGNT";
		return p5;
	end;
	if p5 < 1E+180 and p5 >= 1E+177 then
		p5 = tostring(p5 / 1E+177):sub(1, 5) .. "OQQGNT";
		return p5;
	end;
	if p5 < 1E+183 and p5 >= 1E+180 then
		p5 = tostring(p5 / 1E+180):sub(1, 5) .. "NQQGNT";
		return p5;
	end;
	if p5 < 1E+186 and p5 >= 1E+183 then
		p5 = tostring(p5 / 1E+183):sub(1, 5) .. "SXGNTL";
		return p5;
	end;
	if p5 < 1E+189 and p5 >= 1E+186 then
		p5 = tostring(p5 / 1E+186):sub(1, 5) .. "USXGNTL";
		return p5;
	end;	
	if p5 < 1E+192 and p5 >= 1E+189 then
		p5 = tostring(p5 / 1E+189):sub(1, 5) .. "DSXGNTL";
		return p5;
	end;	
	if p5 < 1E+195 and p5 >= 1E+192 then
		p5 = tostring(p5 / 1E+192):sub(1, 5) .. "TSXGNTL";
		return p5;
	end;	
	if p5 < 1E+198 and p5 >= 1E+195 then
		p5 = tostring(p5 / 1E+195):sub(1, 5) .. "QTSXGNTL";
		return p5;
	end;	
	if p5 < 1E+201 and p5 >= 1E+198 then
		p5 = tostring(p5 / 1E+198):sub(1, 5) .. "QNSXGNTL";
		return p5;
	end;	
	if p5 < 1E+204 and p5 >= 1E+201 then
		p5 = tostring(p5 / 1E+201):sub(1, 5) .. "SXSXGNTL";
		return p5;
	end;	
	if p5 < 1E+207 and p5 >= 1E+204 then
		p5 = tostring(p5 / 1E+204):sub(1, 5) .. "SPSXGNTL";
		return p5;
	end;	
	if p5 < 1E+210 and p5 >= 1E+207 then
		p5 = tostring(p5 / 1E+189):sub(1, 5) .. "OSXGNTL";
		return p5;
	end;	
	if p5 < 1E+213 and p5 >= 1E+210 then
		p5 = tostring(p5 / 1E+210):sub(1, 5) .. "NVSXGNTL";
		return p5;
	end;
	if p5 < 1E+216 and p5 >= 1E+213 then
		p5 = tostring(p5 / 1E+213):sub(1, 5) .. "SPTGNTL";
		return p5;
	end;	
	if p5 < 1E+219 and p5 >= 1E+216 then
		p5 = tostring(p5 / 1E+216):sub(1, 5) .. "USPTGNTL";
		return p5;
	end;	
	if p5 < 1E+222 and p5 >= 1E+219 then
		p5 = tostring(p5 / 1E+219):sub(1, 5) .. "DSPTGNTL";
		return p5;
	end;	
	if p5 < 1E+225 and p5 >= 1E+222 then
		p5 = tostring(p5 / 1E+222):sub(1, 5) .. "TSPTGNTL";
		return p5;
	end;	
	if p5 < 1E+228 and p5 >= 1E+225 then
		p5 = tostring(p5 / 1E+225):sub(1, 5) .. "QTSPTGNTL";
		return p5;
	end;	
	if p5 < 1E+231 and p5 >= 1E+228 then
		p5 = tostring(p5 / 1E+228):sub(1, 5) .. "QNSPTGNTL";
		return p5;
	end;	
	if p5 < 1E+234 and p5 >= 1E+231 then
		p5 = tostring(p5 / 1E+231):sub(1, 5) .. "SXSPTGNTL";
		return p5;
	end;	
	if p5 < 1E+237 and p5 >= 1E+234 then
		p5 = tostring(p5 / 1E+234):sub(1, 5) .. "SPSPTGNTL";
		return p5;
	end;	
	if p5 < 1E+240 and p5 >= 1E+237 then
		p5 = tostring(p5 / 1E+237):sub(1, 5) .. "OSPTGNTL";
		return p5;
	end;	
	if p5 < 1E+243 and p5 >= 1E+240 then
		p5 = tostring(p5 / 1E+240):sub(1, 5) .. "NVSPTGNTL";
		return p5;
	end;	
	if p5 < 1E+246 and p5 >= 1E+243 then
		p5 = tostring(p5 / 1E+243):sub(1, 5) .. "OTGNTL";
		return p5;
	end;	
	if p5 < 1E+249 and p5 >= 1E+246 then
		p5 = tostring(p5 / 1E+246):sub(1, 5) .. "UOTGNTL";
		return p5;
	end;	
	if p5 < 1E+252 and p5 >= 1E+249 then
		p5 = tostring(p5 / 1E+249):sub(1, 5) .. "DOTGNTL";
		return p5;
	end;		
	if p5 < 1E+255 and p5 >= 1E+252 then
		p5 = tostring(p5 / 1E+252):sub(1, 5) .. "TOTGNTL";
		return p5;
	end;	
	if p5 < 1E+258 and p5 >= 1E+255 then
		p5 = tostring(p5 / 1E+255):sub(1, 5) .. "QTOTGNTL";
		return p5;
	end;	
	if p5 < 1E+261 and p5 >= 1E+258 then
		p5 = tostring(p5 / 1E+258):sub(1, 5) .. "QNOTGNTL";
		return p5;
	end;	
	if p5 < 1E+264 and p5 >= 1E+261 then
		p5 = tostring(p5 / 1E+261):sub(1, 5) .. "SXOTGNTL";
		return p5;
	end;	
	if p5 < 1E+267 and p5 >= 1E+264 then
		p5 = tostring(p5 / 1E+264):sub(1, 5) .. "SPOTGNTL";
		return p5;
	end;	
	if p5 < 1E+270 and p5 >= 1E+267 then
		p5 = tostring(p5 / 1E+267):sub(1, 5) .. "OTOTGNTL";
		return p5;
	end;	
	if p5 < 1E+273 and p5 >= 1E+270 then
		p5 = tostring(p5 / 1E+270):sub(1, 5) .. "NVOTGNTL";
		return p5;
	end;	
	if p5 < 1E+276 and p5 >= 1E+273 then
		p5 = tostring(p5 / 1E+273):sub(1, 5) .. "NONGNTL";
		return p5;
	end;	
	if p5 < 1E+279 and p5 >= 1E+276 then
		p5 = tostring(p5 / 1E+276):sub(1, 5) .. "UNONGNTL";
		return p5;
	end;	
	if p5 < 1E+282 and p5 >= 1E+279 then
		p5 = tostring(p5 / 1E+279):sub(1, 5) .. "DNONGNTL";
		return p5;
	end;	
	if p5 < 1E+285 and p5 >= 1E+282 then
		p5 = tostring(p5 / 1E+282):sub(1, 5) .. "TNONGNTL";
		return p5;
	end;	
	if p5 < 1E+288 and p5 >= 1E+285 then
		p5 = tostring(p5 / 1E+285):sub(1, 5) .. "QTNONGNTL";
		return p5;
	end;	
	if p5 < 1E+291 and p5 >= 1E+288 then
		p5 = tostring(p5 / 1E+288):sub(1, 5) .. "QNNONGNTL";
		return p5;
	end;	
	if p5 < 1E+294 and p5 >= 1E+291 then
		p5 = tostring(p5 / 1E+291):sub(1, 5) .. "SXNONGNTL";
		return p5;
	end;	
	if p5 < 1E+297 and p5 >= 1E+294 then
		p5 = tostring(p5 / 1E+294):sub(1, 5) .. "SPNONGNTL";
		return p5;
	end;	
	if p5 < 1E+300 and p5 >= 1E+297 then
		p5 = tostring(p5 / 1E+297):sub(1, 5) .. "OTNONGNTL";
		return p5;
	end;	
	if p5 < 1E+303 and p5 >= 1E+300 then
		p5 = tostring(p5 / 1E+300):sub(1, 5) .. "NONONGNTL";
		return p5;
	end;	
	if not (p5 < 1.7976931348E+306) or not (p5 >= 1E+303) then
		if p5 >= 1.7976931348E+303 then
			p5 = "Inf";
		end;
		return p5;
	end;
	p5 = tostring(p5 / 1E+306):sub(1, 5) .. "Inf";
	return p5;
end;
return v1;
