--PSY骨架超载
local s,id,o=GetID()
function c36970611.initial_effect(c)
	--activate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_ACTIVATE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetTarget(s.tg)
	e9:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e9)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,5))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetValue(id)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.actcon)
	e0:SetCost(s.scost)
	c:RegisterEffect(e0)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36970611,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(2)
	e2:SetCost(c36970611.cost)
	e2:SetTarget(c36970611.target)
	e2:SetOperation(c36970611.operation)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36970611,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c36970611.thtg)
	e3:SetOperation(c36970611.thop)
	c:RegisterEffect(e3)
end
function c36970611.tgfilter(c,tp,xc)
	return c:IsAbleToRemove(tp,POS_FACEDOWN) and c~=xc
end
function c36970611.cfilter(c,tp,xc)
	return c:IsSetCard(0xc1) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c36970611.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp,xc)
end
function c36970611.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local xc=nil
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then xc=e:GetHandler() end
	if chk==0 then return Duel.IsExistingMatchingCard(c36970611.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp,xc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c36970611.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp,xc)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function c36970611.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove(tp,POS_FACEDOWN) end
	if chk==0 then return true end
	local xg=nil
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then xg=e:GetHandler() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,xg,tp,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c36970611.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c36970611.thfilter(c)
	return c:IsSetCard(0xc1) and not c:IsCode(36970611) and c:IsAbleToHand()
end
function c36970611.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36970611.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c36970611.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c36970611.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.cfilter(c)
	return c:IsSetCard(0xc1)  and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local res=e:GetHandler():IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN,tp)
	if chk==0 then return res and res:GetOwner()==c and res:GetValue()==id
		or not c:IsStatus(STATUS_SET_TURN)
	 end
end
function s.actcon(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end