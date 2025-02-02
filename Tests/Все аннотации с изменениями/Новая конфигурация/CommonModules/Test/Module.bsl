﻿Процедура ПриСозданииЗадач_а(
	ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка, НомерШага) Экспорт 
	//Код в расширении
КонецПроцедуры

Процедура ПолучитьДанныеПоШтрихкодам(КэшированныеЗначения, Штрихкоды) Экспорт
	ТекДанные.НесколькоЕдиничныхУпаковок      = Выборка.КоличествоЕдиничныхУпаковок > 1 И Не Выборка.ТоварноеМесто;
	ТекДанные.НеизвестныйШтрихкод             = Ложь;
	ТекДанные.ВариантРасчетаЦеныНабора        = Выборка.ВариантРасчетаЦеныНабора;
	ТекДанные.ПредставлениеНоменклатуры       = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
		Выборка.НоменклатураПредставление,
		Выборка.ХарактеристикаПредставление);	
КонецПроцедуры

Процедура ПриСозданииЗадач(
	ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка, НомерШага) Экспорт 
	//Код равен 2
КонецПроцедуры

Процедура ПриСозданииЗадач1(
	ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка, НомерШага) Экспорт 
	//Код в расширении
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНомерГТДПриСозданииЗадач(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Действия = Новый Структура;
	Действия.Вставить("ЗаполнитьСтрануПроисхожденияДляНомераГТД", Новый Структура("НомерГТД", ВыбранноеЗначение));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, Действия, Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЗадачДокументаОснованияСервер(ВыбранноеЗначение)
	ВзаиморасчетыСервер.ПриИзмененииПараметровМеханизма(ЭтотОбъект);
КонецПроцедуры