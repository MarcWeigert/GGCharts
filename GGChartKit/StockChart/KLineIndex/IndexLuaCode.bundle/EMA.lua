-- EMA 指标
-- @param list K线数组
-- @param getMethod 计算字段
-- @param param {5, 10, 20, 40}

function EMAIndex(aryList, getMethod, param)

	local listMapIndex = {}
	local titles = {}

	for i = 1, #param, 1 do

		local title = "EMA"..param[i]
		local cycle = param[i]
		local funcEMA = EMA(getMethod, cycle, aryList)
		local aryMANIndex = {}

		titles[i] = title
		listMapIndex[title] = aryMANIndex

		for j = 1, #aryList, 1 do

			aryMANIndex[j] = funcEMA(j)
		end
	end

	local aryEMAIndex = {}

	for j = 1, #aryList, 1 do

		local ma = {}

		for i = 1, #titles, 1 do

			local title = titles[i]
			local aryMaNIndex = listMapIndex[title]

			ma[title] = aryMaNIndex[j]
		end

		aryEMAIndex[j] = ma
	end

	return aryEMAIndex
end
