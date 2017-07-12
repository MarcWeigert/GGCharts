-- MA(X, N) 求X在N个周期内的简单移动平均。
function MA(getMethod, sub)

	return function (index, aryKLine)

		local sum = 0

		if (sub > index) then

			return "1.175494351e-38F"
		end

		for i = 1, sub, 1 do

			sum = sum + aryKLine[index][getMethod]
			index = index - 1
		end

		return sum / sub
	end
end

-- VD(X, N): 求X在N个周期内的方差。
function VD(getMethod, sub)

	local funcMA = MA(getMethod, sub)

	return function (index, aryKLine)
		
		if ((index - sub) < 0) then
		
			return 0.0
		end
		
		local sum = 0
		local ma = funcMA(index, aryKLine)
		
		for i = 1, sub, 1 do
		
			xn = aryKLine[index][getMethod]
			d = (ma - xn) * (ma - xn)
			sum = sum + d
			index = index - 1
		end
		
		return sum / sub
	end
end

-- STD(X, N): 求X在N个周期内的标准差。
function STD(getMethod, sub)

	local funcVD = VD(getMethod, sub)
	
	return function (index, aryKLine)
	
		vd = funcVD(index, aryKLine)
		
		if (vd == "1.175494351e-38F") then
			
			return "1.175494351e-38F"
		end
		
		return math.sqrt(vd)
	end
end

-- REF(X, N): 引用X在N个周期前的值。
function REF(getMethod, sub)

	return function (index, aryKLine)
		
		index = index - sub
		
		if (index < 1) then
			
			return aryKLine[1][getMethod]
		end
		
		if (index > #aryKLine) then
	
			index = #aryKLine
		end
		
		return aryKLine[index][getMethod]
	end
end

-- LLV(X, N): 求X在N个周期内的最小值
function LLV(getMethod, sub)
	
	return function (index, aryKLine)
		
		local low = aryKLine[index][getMethod]
		
		for i = 1, sub, 1 do
		
			if (index < 1) then
			
				index = 1
			end
		
			if (index > #aryKLine) then
	
				index = #aryKLine
			end
			
			kLow = aryKLine[index][getMethod]
			low = low > kLow and kLow or low
			index = index - 1
		end
		
		return low
	end
end

-- HHV(X,N): 求X在N个周期内的最大值。
function HHV(getMethod, sub)
	
	return function (index, aryKLine)
	
		local high = aryKLine[index][getMethod]
	
		for i = 1, sub, 1 do 
		
			if (index < 1) then
			
				index = 1
			end
		
			if (index > #aryKLine) then
	
				index = #aryKLine
			end
			
			kHigh = aryKLine[index][getMethod]
			high = high > kHigh and high or kHigh
			index = index - 1
		end
		
		return high
	end
end

-- EMA(X, N): 求X在N日移动均匀值
function EMA(getMethod, sub)
		
	return function (index, aryKLine)
		
		if (index <= 1) then 
		
			return aryKLine[1][getMethod]
		end
			
		price = aryKLine[index][getMethod]
		funcEMA = EMA(getMethod, sub)
		count = sub + 1
	
		return (2 * price + (sub - 1) * funcEMA(index - 1, aryKLine)) / count
	end
end

--- SMA(X, N, M): 求X在N日M平滑系数移动平均, N必须大于M
function SMA(getMethod, sub, coe)

	return function (index, aryKLine)
		
		if (index <= 1) then
		
			return aryKLine[1][getMethod] 
		end
		
		price = aryKLine[index][getMethod]
		funcSMA = SMA(getMethod, sub, coe)
		
		return (coe * price + (sub - coe) * funcSMA(index - 1, aryKLine)) / sub
	end
end
