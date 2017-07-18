-- TD指标
-- @param aryList k线
-- @param getMethodLow 最高价字段
-- @param getMethodClose 收盘价
-- @param param 9
-- @return {"dir" : 1 - 9, 向上九转, -1 - -9, 向下, "arrow" : 1, 0, -1}
function TDIndex(aryList, getMethodLow, getMethodClose, getMethodHigh, param)

  upNo = 0
  upStart = 0
  downNo = 0
  downStart = 0

  local funcRef1 = REF(getMethodClose, 1, aryList)
  local funcRef4 = REF(getMethodClose, 4, aryList)
  local funcRef5 = REF(getMethodClose, 5, aryList)

  local aryTDs = {}

  for i = 1, #aryList, 1 do

    local td = {}

    -- 向上
    if (aryList[i][getMethodClose] > funcRef4(i) and funcRef1(i) <= funcRef5(i)) then
      upNo = 1
      upStart = 1
      downStart = 0
    elseif (upStart and upNo < param) then
      upNo = upNo + 1
    elseif (upStart and upNo == param) then
      upNo = 0
    end

    if (aryList[i][getMethodClose] < funcRef4(i)) then
      upNo = 0
      upStart = 0
    end

    -- 向下
    if (aryList[i][getMethodClose] < funcRef4(i) and funcRef1(i) >= funcRef5(i)) then
      downStart = 1
      downNo = 1
      upStart = 0
    elseif (downStart == 1 and downNo < param) then
      downNo = downNo + 1
    elseif (downStart == 1 and downNo == param) then
      downNo = 0
    end

    if (aryList[i][getMethodClose] > funcRef4(i)) then
      downNo = 0
      downStart = 0
    end

    td["upNo"] = upNo
    td["downNo"] = downNo
    aryTDs[i] = td
  end

  -- 过滤
  local funcLowRef1 = REF(getMethodLow, 1, aryList)
  local funcHighRef1 = REF(getMethodHigh, 1, aryList)

  local upParam = false
  local downParam = false

  for i = 1, #aryTDs, 1 do

    aryTDs[i]["dir"] = 0
    aryTDs[i]["arrow"] = 0

    -- 红色箭头
    if (upParam and (aryList[i][getMethodClose] > funcRef1(i))) then

      aryTDs[i]["arrow"] = -1
      upParam = false
    end

    -- 绿色箭头
    if (downParam and (aryList[i][getMethodClose] < funcRef1(i))) then

      aryTDs[i]["arrow"] = 1
      downParam = false
    end

    if (aryTDs[i]["upNo"] == param) then

      if (aryList[i][getMethodClose] > funcLowRef1(i)) then
        aryTDs[i]["arrow"] = -1
      else
        upParam = true
      end

      updateNumber(aryTDs, param, "dir", i)
    end

    if (aryTDs[i]["downNo"] == param) then

      if (aryList[i][getMethodClose] < funcHighRef1(i)) then
        aryTDs[i]["arrow"] = 1
      else
        downParam = true
      end

      updateNumber(aryTDs, -param, "dir", i)
    end
  end

  return aryTDs
end

function updateNumber(aryList, param, setMethod, index)

  count = math.abs(param)
  base = param >= 0 and -1 or 1

  for i = 1, count, 1 do
    aryList[index][setMethod] = param
    index = index - 1
    param = param + base
  end
end
