﻿&НаКлиенте
Перем РВ; // переменная, используемая для обслуживания регулярных выражений
&НаКлиенте
Перем ИмяФайлаРасширения; // путь к файлу, разбираемого алгоритмом во время итерации

// Блок переменных, хранящих содержимое файлов во время итерации разбора
&НаКлиенте
Перем СодержимоеФайлаРасширения; // содержимое файла расширения
&НаКлиенте
Перем СодержимоеФайлаОсновнойКонфигурации; // содержимое файла основной конфигурации
&НаКлиенте
Перем СодержимоеФайлаНовойКонфигурации; // содержимое файла новой конфигурации
&НаКлиенте
Перем СодержимоеФайлаФормыОсновнойКонфигурации; // содержимое файла формы основной конфигурации
&НаКлиенте
Перем СодержимоеФайлаФормыНовойКонфигурации; // содержимое файла формы новой конфигурации

&НаСервере
Перем СоответствиеРусскихИАнглийскихИмен; // кеш имен

#Область РаботаСФормой 
&НаКлиенте
Процедура ПутьККаталогамНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ИмяРеквизита = Элемент.Имя;
	ДопПараметры = Новый Структура("ИмяРеквизита", ИмяРеквизита);
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);    
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораКаталога", ЭтотОбъект, ДопПараметры);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
КонецПроцедуры


&НаКлиенте
Процедура ПутьКФайламНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ИмяРеквизита = Элемент.Имя;
	ДопПараметры = Новый Структура("ИмяРеквизита", ИмяРеквизита);
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);    
	ДиалогВыбораФайла.Фильтр = "Исполняемые файлы| *.exe";
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораФайла", ЭтотОбъект, ДопПараметры);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораКаталога(Результат, ДопПараметры) Экспорт
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма[ДопПараметры.ИмяРеквизита] = Результат[0];   
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФайла(Результат, ДопПараметры) Экспорт
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма[ДопПараметры.ИмяРеквизита] = Результат[0];   
	ПутьКПрограммеСравненияПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИнициироватьРегулярныеВыражения();
	ИмяФайлаРасширения = "";
КонецПроцедуры
#КонецОбласти

#Область РегулярныеВыражения
&НаКлиенте
Процедура ИнициироватьРегулярныеВыражения()     
	ИмяМакета = "ВнешняяОбработка.АнализРасширенияПриОбновлении.Макет.RegEx"; 
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("ИмяМакета", ИмяМакета);
	ПараметрыПодключения.Вставить("УстановитьЕслиНеПодключено", Истина);
	ОповещениеПослеПодключения = Новый ОписаниеОповещения("ПослеПодключенияКомпоненты",  ЭтотОбъект, ПараметрыПодключения);
	
	НачатьПодключениеВнешнейКомпоненты(ОповещениеПослеПодключения,
        ИмяМакета, 
		"Component",
        ТипВнешнейКомпоненты.Native);  
		
КонецПроцедуры // ()

&НаКлиенте
Функция ПоискПоШаблону(ШаблонПоиска, ГдеИскать)
	НайденныеФрагменты = Новый Массив;
	РВ.НайтиСовпадения(ГдеИскать, ШаблонПоиска, Истина);
	Пока РВ.Следующий() Цикл
		НайденныйУчасток = РВ.ТекущееЗначение;  
		КоличествоВложенныхГрупп = РВ.КоличествоВложенныхГрупп();
		РезультатПоиска = Новый Структура("Значение,Группы");
		РезультатПоиска.Значение = НайденныйУчасток;     
		НайденныеГруппы = Новый Массив; 
		Для СчетВнутренний = 0 По КоличествоВложенныхГрупп - 1 Цикл
			Подгруппа = РВ.ПолучитьПодгруппу(СчетВнутренний);
			НайденныеГруппы.Добавить(Подгруппа);    
		КонецЦикла;
        РезультатПоиска.Группы = НайденныеГруппы;
		НайденныеФрагменты.Добавить(РезультатПоиска);
	КонецЦикла;	
	
	Возврат НайденныеФрагменты;
КонецФункции // ()

&НаКлиенте
Процедура ПослеПодключенияКомпоненты(Подключено, ПараметрыПодключения) Экспорт
	Если Подключено Тогда
		СоздатьПеременнуюДляРегулярныхВыражений();                           
	ИначеЕсли ПараметрыПодключения.УстановитьЕслиНеПодключено Тогда
		НачатьУстановкуВнешнейКомпоненты( , ПараметрыПодключения.ИмяМакета);     
		ПараметрыПодключения.УстановитьЕслиНеПодключено = Ложь;
		ОповещениеПослеПодключения = Новый ОписаниеОповещения("ПослеПодключенияКомпоненты", ЭтотОбъект, ПараметрыПодключения);
		НачатьПодключениеВнешнейКомпоненты(ОповещениеПослеПодключения , ПараметрыПодключения, 
			"Component", ТипВнешнейКомпоненты.Native);
	Иначе
		ВызватьИсключение "Не удалось подключить внешнюю компоненту RegEx";
    КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура СоздатьПеременнуюДляРегулярныхВыражений()
	РВ = Новый("AddIn.Component.RegEx"); 
	РВ.Global = Истина;
	РВ.IgnoreCase = Истина;
	РВ.MultiLine = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура Анализ(Команда)
	Если ПроверитьЗаполнение() = Ложь Тогда
		Возврат;
	КонецЕсли;
	РезультатыРазбора.Очистить();
	АнализФайловРасширения();
	АнализФайловОбновляемойКонфигураций();
	СравнитьМетоды();
	ВывестиРезультатВДереве();
	РазвернутьДерево();
КонецПроцедуры

&НаКлиенте
Процедура АнализФайловРасширения()
	АнализФайловРасширенияВМодулях();
	ЗаполнитьФайлыДляПроверки();
КонецПроцедуры

&НаКлиенте
Функция СодержимоеФайла(ИмяФайла)
	ТекстовыйФайл = Новый ТекстовыйДокумент;
	ТекстовыйФайл.Прочитать(ИмяФайла);
	Возврат ТекстовыйФайл.ПолучитьТекст();
КонецФункции // ()

&НаКлиенте
Процедура АнализФайловРасширенияВМодулях()
	НайденныеФайлы = НайтиФайлы(ФайлыРасширения, "*.bsl", Истина);
	Для каждого НайденныеФайл Из НайденныеФайлы Цикл
		ИмяФайла = НайденныеФайл.ПолноеИмя;
		Если ЭтоСобственныйОбъектРасширения(ИмяФайла) Тогда
			Продолжить;
		КонецЕсли;
		СодержимоеФайла = СодержимоеФайла(ИмяФайла);
		Если ЭтоМодульФормы(ИмяФайла) Тогда
			РазобратьФорму(ИмяФайла, СодержимоеФайла);
		КонецЕсли;
		// BSLLS:LineLength-off
		ШаблонПоиска = "^\s*?&(Перед|Вместо|После|ИзменениеИКонтроль)\s*\(\""([\w\W]*?)\""\)*\s((?:Процедура|Функция)\s*([\w\W]*?)\([\w\W]*?\)\s*(?:Экспорт)*\s*$)([\w\W]*?)(КонецПроцедуры|КонецФункции)";
		// BSLLS:LineLength-on
		РезультатыПоиска = ПоискПоШаблону(ШаблонПоиска, СодержимоеФайла);
		Для каждого РезультатПоиска Из РезультатыПоиска Цикл
			Подстроки = РезультатПоиска.Группы;
			НоваяСтрока = РезультатыРазбора.Добавить(); 
			НоваяСтрока.ИдСтроки = Новый УникальныйИдентификатор;
			НоваяСтрока.Аннотация = Подстроки[0];
			НоваяСтрока.ПереопределяемыйМетод = Подстроки[1];
			НоваяСтрока.НовыйМетод = Подстроки[3];
			НоваяСтрока.ФайлРасширения = ИмяФайла;
			
			МетодРасширение = Новый Структура;
			МетодРасширение.Вставить("ШапкаМетода", Подстроки[2]);
			МетодРасширение.Вставить("ТелоМетода", Подстроки[4]);
			МетодРасширение.Вставить("ЗавершениеМетода", Подстроки[5]);
			НоваяСтрока.МетодРасширение = МетодРасширение;
			
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ЭтоСобственныйОбъектРасширения(ИмяФайла)
	ФайлОбъектаМетаданных = ФайлОбъектаМетаданных(ИмяФайла);
	Если ФайлОбъектаМетаданных = "" Тогда
		Возврат Истина;
	КонецЕсли;
	СодержимоеФайла = СодержимоеФайла(ФайлОбъектаМетаданных);
	СтрокаЗаимствования = "<ObjectBelonging>";
	Результат = СтрНайти(СодержимоеФайла, СтрокаЗаимствования) = 0;
	Возврат Результат;
КонецФункции // ()

&НаКлиенте
Функция ФайлОбъектаМетаданных(ИмяФайла)
	ОтносительныйПуть = СтрЗаменить(ИмяФайла, ФайлыРасширения, "");
	ЧастиФайла = СтрРазделить(ОтносительныйПуть, "\", Ложь);
	МинимальнаяДлинаПути = 2;
	Если ЧастиФайла.Количество() < МинимальнаяДлинаПути Тогда
		Возврат Ложь;
	КонецЕсли;
	ЧастиНовогоПути = Новый Массив;
	ЧастиНовогоПути.Добавить(ФайлыРасширения);
	ЧастиНовогоПути.Добавить(ЧастиФайла[0]); // типОбъекта
	ЧастиНовогоПути.Добавить(ЧастиФайла[1] + ".xml"); // имяОбъекта
	ПутьКФайлу = СтрСоединить(ЧастиНовогоПути, "\");
	ФайлНаДиске = Новый Файл(ПутьКФайлу);
	Если ФайлНаДиске.Существует() Тогда
		Возврат ПутьКФайлу;
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции // ()

&НаКлиенте
Функция ПутьКФормеМодуля(ИмяФайлаМодуля)
	Возврат СтрЗаменить(ИмяФайлаМодуля, "\Module.bsl", ".xml");
КонецФункции // ()

&НаКлиенте
Процедура РазобратьФорму(ИмяФайлаМодуля, СодержимоеФайлаМодуля)
	ПутьКФорме = ПутьКФормеМодуля(ИмяФайлаМодуля);
	ФайлНаДиске = Новый Файл(ПутьКФорме);
	Если ФайлНаДиске.Существует() = Ложь Тогда
		Возврат;
	КонецЕсли;
	СодержимоеФайлаФормы = СодержимоеФайла(ПутьКФорме);
	РазобратьМетодыСамойФормы(ИмяФайлаМодуля, СодержимоеФайлаФормы, СодержимоеФайлаМодуля);
	РазобратьМетодыРеквизитов(ИмяФайлаМодуля, СодержимоеФайлаФормы, СодержимоеФайлаМодуля);
КонецПроцедуры

&НаКлиенте
Процедура РазобратьМетодыРеквизитов(ИмяФайлаМодуля, СодержимоеФайла, СодержимоеФайлаМодуля)
	ШаблонПоиска = "<InputField\s+name=""(\S+)""(?:[\s\S](?!InputField))*?<\/Events>";
	РезультатыПоиска = ПоискПоШаблону(ШаблонПоиска, СодержимоеФайла);
	Для каждого РезультатПоиска Из РезультатыПоиска Цикл
		Подстроки = РезультатПоиска.Группы;
		РеквизитФормы = Подстроки[0];
		РазобратьМетодыФормы(РезультатПоиска.Значение, РеквизитФормы, ИмяФайлаМодуля, СодержимоеФайлаМодуля);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура РазобратьМетодыСамойФормы(ИмяФайлаМодуля, СодержимоеФайла, СодержимоеФайлаМодуля)
	ШаблонПоиска = "<?xml version.*?(?:[\s\S](?!InputField))*?<\/Events>";
	РезультатыПоиска = ПоискПоШаблону(ШаблонПоиска, СодержимоеФайла);
	Для каждого РезультатПоиска Из РезультатыПоиска Цикл
		РазобратьМетодыФормы(РезультатПоиска.Значение, "", ИмяФайлаМодуля, СодержимоеФайлаМодуля);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура РазобратьМетодыФормы(ГдеИщем, РеквизитФормы, ИмяФайлаМодуля, СодержимоеФайлаМодуля)
	ШаблонПоискаСобытий = "<Event\sname=""(\S*)"".*callType=""(\S*)"".*>(\S*).*?<\/Event>";
	РезультатыПоискаСобытий = ПоискПоШаблону(ШаблонПоискаСобытий, ГдеИщем);
	Для каждого РезультатПоискаСобытий Из РезультатыПоискаСобытий Цикл
		Подстроки = РезультатПоискаСобытий.Группы;
		НоваяСтрока = РезультатыРазбора.Добавить();
		НоваяСтрока.ИдСтроки = Новый УникальныйИдентификатор;
		НоваяСтрока.ПереопределенНаФорме = Истина;
		НоваяСтрока.Аннотация = Подстроки[1];
		НоваяСтрока.ПереопределяемыйМетод = Подстроки[0]; // дописать преобразование в русский
		НоваяСтрока.НовыйМетод = Подстроки[2];
		НоваяСтрока.РеквизитФормы = РеквизитФормы;
		НоваяСтрока.ФайлРасширения = ИмяФайлаМодуля;    
		// BSLLS:LineLength-off
		ШаблонПоискаМетода = "^\s*?((?:Процедура|Функция)\s*%1\([\w\W]*?\)\s*(?:Экспорт)*\s*$)([\w\W]*?)(КонецПроцедуры|КонецФункции)";    
		// BSLLS:LineLength-on
		СтрокаПоиска = СтрШаблон(ШаблонПоискаМетода, НоваяСтрока.НовыйМетод);   
		РезультатыПоискаМетода = ПоискПоШаблону(СтрокаПоиска, СодержимоеФайлаМодуля);
		Для каждого РезультатПоискаМетода Из РезультатыПоискаМетода Цикл  
			ПодстрокиМетода = РезультатПоискаМетода.Группы;
			МетодРасширение = Новый Структура;
			МетодРасширение.Вставить("ШапкаМетода", ПодстрокиМетода[0]);
			МетодРасширение.Вставить("ТелоМетода", ПодстрокиМетода[1]);
			МетодРасширение.Вставить("ЗавершениеМетода", ПодстрокиМетода[2]);
			НоваяСтрока.МетодРасширение = МетодРасширение;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ЭтоМодульФормы(ПутьКФайлу)
	Возврат СтрНайти(ПутьКФайлу, "Ext\Form") > 0;
КонецФункции // ()

&НаКлиенте
Процедура АнализФайловОбновляемойКонфигураций()
	Для каждого Строка Из РезультатыРазбора Цикл
		Отбор = Новый Структура("ФайлРасширения", Строка.ФайлРасширения);
		НайденныеСтроки = ФайлыДляПроверки.НайтиСтроки(Отбор);
		Если ПрочитатьСодержимоеФайлов(Строка, НайденныеСтроки[0]) = Ложь Тогда
			Продолжить;
		КонецЕсли;
		РазобратьСтроку(Строка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФайлыДляПроверки()
	ЗаполнитьФайламиРасширения();
	ЗаполнитьФайламиКонфигурации("ФайлОсновнойКонфигурации");
	ЗаполнитьФайламиКонфигурации("ФайлНовойКонфигурации");
КонецПроцедуры // ()

&НаКлиенте
Процедура ЗаполнитьФайламиРасширения()
	// свертка тз на клиенте недоступна - выполним самостоятельно на клиенте
	ФайлыДляПроверки.Очистить();
	УникальныеФайлы = Новый Соответствие;
	Для каждого Строка Из РезультатыРазбора Цикл
		ЗначениеВКеше = УникальныеФайлы.Получить(Строка.ФайлРасширения);
		Если ЗначениеВКеше = Неопределено Тогда
			УникальныеФайлы.Вставить(Строка.ФайлРасширения, Строка.ПереопределенНаФорме);
		Иначе
			Если Строка.ПереопределенНаФорме = Истина И ЗначениеВКеше = Ложь Тогда
				УникальныеФайлы.Вставить(Строка.ФайлРасширения, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Для каждого Строка Из УникальныеФайлы Цикл
		НоваяСтрока = ФайлыДляПроверки.Добавить();
		НоваяСтрока.ФайлРасширения = Строка.Ключ;
		НоваяСтрока.ЕстьМетодыПереопределенныеВФорме = Строка.Значение;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФайламиКонфигурации(ИмяРеквизита)
	Если ИмяРеквизита = "ФайлОсновнойКонфигурации" Тогда
		ПутьКФайлам = ФайлыОбновляемойКонфигурации;
	Иначе
		ПутьКФайлам = ФайлыНовойКонфигурации;
	КонецЕсли;
	Для каждого Строка Из ФайлыДляПроверки Цикл
		ИмяФайла = СтрЗаменить(Строка.ФайлРасширения, ФайлыРасширения, ПутьКФайлам);
		ФайлНаДиске = Новый Файл(ИмяФайла);
		Если ФайлНаДиске.Существует() Тогда
			Строка[ИмяРеквизита] = ИмяФайла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ПрочитатьСодержимоеФайлов(СтрокаПроверки, СтрокаТаблицыФайлов)
	Если НЕ ЗначениеЗаполнено(СтрокаТаблицыФайлов.ФайлОсновнойКонфигурации)
		ИЛИ НЕ ЗначениеЗаполнено(СтрокаТаблицыФайлов.ФайлНовойКонфигурации) Тогда
		Возврат Ложь;
	КонецЕсли;
	Если СтрокаТаблицыФайлов.ФайлРасширения <> ИмяФайлаРасширения Тогда
		ИмяФайлаРасширения = СтрокаТаблицыФайлов.ФайлРасширения;
		СодержимоеФайлаРасширения = СодержимоеФайла(СтрокаТаблицыФайлов.ФайлРасширения);
		СодержимоеФайлаОсновнойКонфигурации = СодержимоеФайла(СтрокаТаблицыФайлов.ФайлОсновнойКонфигурации);
		СодержимоеФайлаНовойКонфигурации = СодержимоеФайла(СтрокаТаблицыФайлов.ФайлНовойКонфигурации);
		Если СтрокаТаблицыФайлов.ЕстьМетодыПереопределенныеВФорме Тогда
			ПутьКФорме = ПутьКФормеМодуля(СтрокаТаблицыФайлов.ФайлОсновнойКонфигурации);
			ФайлНаДиске = Новый Файл(ПутьКФорме);
			Если ФайлНаДиске.Существует() Тогда
				СодержимоеФайлаФормыОсновнойКонфигурации = СодержимоеФайла(ПутьКФорме);
			Иначе
				СодержимоеФайлаФормыОсновнойКонфигурации = "";
			КонецЕсли;
			
			ПутьКФорме = ПутьКФормеМодуля(СтрокаТаблицыФайлов.ФайлНовойКонфигурации);
			ФайлНаДиске = Новый Файл(ПутьКФорме);
			Если ФайлНаДиске.Существует() Тогда
				СодержимоеФайлаФормыНовойКонфигурации = СодержимоеФайла(ПутьКФорме);
			Иначе
				СодержимоеФайлаФормыНовойКонфигурации = "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура РазобратьСтроку(СтрокаПроверки)
	ИмяМетода = СтрокаПроверки.ПереопределяемыйМетод;
	СтрокаПроверки.МетодОсновнаяКонфигурация = МетодКонфигурации(ИмяМетода, СодержимоеФайлаОсновнойКонфигурации);
	СтрокаПроверки.МетодНоваяКонфигурация = МетодКонфигурации(ИмяМетода, СодержимоеФайлаНовойКонфигурации);
	Если СтрокаПроверки.ПереопределенНаФорме Тогда
		ИмяМетодаОсновнойФормы = ИмяМетодаФормы(СтрокаПроверки, СодержимоеФайлаФормыОсновнойКонфигурации);
		СтрокаПроверки.МетодОсновнаяКонфигурация = МетодКонфигурации(ИмяМетодаОсновнойФормы ,
			СодержимоеФайлаОсновнойКонфигурации);
		
		ИмяМетодаНовойФормы = ИмяМетодаФормы(СтрокаПроверки, СодержимоеФайлаФормыНовойКонфигурации);
		СтрокаПроверки.МетодНоваяКонфигурация = МетодКонфигурации(ИмяМетодаНовойФормы, СодержимоеФайлаНовойКонфигурации);

		СтрокаПроверки.ПереопределяемыйМетод = ИмяМетодаОсновнойФормы;  
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция МетодКонфигурации(ИмяМетода, ТекстМодуля)
	Если Не ЗначениеЗаполнено(ИмяМетода) Тогда
		Возврат Неопределено;
	КонецЕсли;
	// BSLLS:LineLength-off
	ШаблонПоискаСПараметром = "^\s*?((?:Процедура|Функция)\s*%1[\w\W]*?\([\w\W]*?\)\s*(?:Экспорт)*\s*$)([\w\W]*?)(КонецПроцедуры|КонецФункции)";
	// BSLLS:LineLength-on
	ШаблонПоиска = СтрШаблон(ШаблонПоискаСПараметром, ИмяМетода);
	РезультатыПоиска = ПоискПоШаблону(ШаблонПоиска, ТекстМодуля);
	Если РезультатыПоиска.Количество() > 1 Тогда
		ВызватьИсключение "Ошибка поиска метода " + ИмяМетода + " найдено более одного определения";
	ИначеЕсли РезультатыПоиска.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Подстроки = РезультатыПоиска[0].Группы;
		Результат = Новый Структура;
		Результат.Вставить("ШапкаМетода", Подстроки[0]);
		Результат.Вставить("ТелоМетода", Подстроки[1]);
		Результат.Вставить("ЗавершениеМетода", Подстроки[2]);
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ИмяМетодаФормы(СтрокаПроверки, ТекстМодуля)
	ИмяМетодаСамойФормы = ИмяМетодаСамойФормы(СтрокаПроверки, ТекстМодуля);
	Если ЗначениеЗаполнено(ИмяМетодаСамойФормы) Тогда
		Возврат ИмяМетодаСамойФормы;
	КонецЕсли;
	ИмяМетодаРеквизитаФормы = ИмяМетодаРеквизитаФормы(СтрокаПроверки, ТекстМодуля);
	Возврат ИмяМетодаРеквизитаФормы;
КонецФункции

&НаКлиенте
Функция ИмяМетодаСамойФормы(СтрокаПроверки, ТекстМодуля)
	ЧтоИщем = СтрокаПроверки.ПереопределяемыйМетод;
	ШаблонПоискаМетодовФормы = "<?xml version.*?(?:[\s\S](?!InputField))*?<\/Events>";
	ШаблонПоискаМетода = "<Event\sname=""%1"".*>(\S*).*?<\/Event>";
	РезультатыПоиска = ПоискПоШаблону(ШаблонПоискаМетодовФормы, ТекстМодуля);
	Для каждого РезультатПоиска Из РезультатыПоиска Цикл
		СтрокаПоискаСобытий = СтрШаблон(ШаблонПоискаМетода, ЧтоИщем);
		РезультатыПоискаСобытий = ПоискПоШаблону(СтрокаПоискаСобытий, РезультатПоиска.Значение);
		Для каждого РезультатПоискаСобытий Из РезультатыПоискаСобытий Цикл
			Возврат РезультатПоискаСобытий.Группы[0];
		КонецЦикла;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Функция ИмяМетодаРеквизитаФормы(СтрокаПроверки, ТекстМодуля)
	ЧтоИщем = СтрокаПроверки.ПереопределяемыйМетод;
	Владелец = СтрокаПроверки.РеквизитФормы;
	ШаблонПоискаМетодовРеквизитов = "<InputField\s+name=""%1""(?:[\s\S](?!InputField))*?<\/Events>";
	ШаблонПоискаМетода = "<Event\sname=""%1"".*>(\S*).*?<\/Event>";
	
	СтрокаПоискаМетодовРеквизитов = СтрШаблон(ШаблонПоискаМетодовРеквизитов, Владелец);
	РезультатыПоиска = ПоискПоШаблону(СтрокаПоискаМетодовРеквизитов, ТекстМодуля);
	Для каждого РезультатПоиска Из РезультатыПоиска Цикл
		СтрокаПоискаСобытий = СтрШаблон(ШаблонПоискаМетода, ЧтоИщем);
		РезультатыПоискаСобытий = ПоискПоШаблону(СтрокаПоискаСобытий, РезультатПоиска.Значение);
		Для каждого РезультатПоискаСобытий Из РезультатыПоискаСобытий Цикл
			Возврат РезультатПоискаСобытий.Группы[0];
		КонецЦикла;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура СравнитьМетоды()
	Для каждого Строка Из РезультатыРазбора Цикл
		Строка.РезультатСравненияМетодов =
			РезультатСравненияМетодов(Строка.МетодОсновнаяКонфигурация, Строка.МетодНоваяКонфигурация);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция РезультатСравненияМетодов(ПервыйМетод, ВторойМетод)
	Если ВторойМетод = Неопределено Тогда
		Возврат "Метод отсутствует в новой конфигурации";
	ИначеЕсли КоличествоАргументов(ПервыйМетод) <> КоличествоАргументов(ВторойМетод) Тогда
		Возврат "Отличается количество аргументов";
	ИначеЕсли ТелоМодуля(ПервыйМетод) <> ТелоМодуля(ВторойМетод) Тогда
		Возврат "Отличаются тексты методов";
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции // ()

&НаКлиенте
Функция КоличествоАргументов(Метод)
	СтрокаПоиска = "[\s\S].*?\(\s*?\)";
	РезультатыПоиска = ПоискПоШаблону(СтрокаПоиска, Метод.ШапкаМетода);
	Если РезультатыПоиска.Количество() > 0 Тогда
		Возврат 0;
	Иначе
		Возврат СтрЧислоВхождений(Метод.ШапкаМетода, ",");
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ТелоМодуля(Метод)
	Если УчитыватьПриСравненииНепечатаемыеСимволы Тогда
		Возврат Метод.ТелоМетода;
	Иначе
		Возврат ТекстСПечатаемымиСимволами(Метод.ТелоМетода);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ТекстСПечатаемымиСимволами(Текст)
	Результат = СтрЗаменить(Текст, " ", "");
	Результат = СтрЗаменить(Результат, Символы.ПС, "");
	Результат = СтрЗаменить(Результат, Символы.ВК, "");
	Результат = СтрЗаменить(Результат, Символы.Таб, "");
	Результат = СтрЗаменить(Результат, Символы.ВТаб, "");
	Результат = СтрЗаменить(Результат, Символы.НПП, "");
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ВывестиРезультатВДереве()
	СоответствиеРусскихИАнглийскихИмен = СоответствиеРусскихИАнглийскихИмен();
	Дерево = РеквизитФормыВЗначение("ДеревоРазбора");
	Дерево.Строки.Очистить();
	Для каждого Строка Из РезультатыРазбора Цикл
		Если Не ЗначениеЗаполнено(Строка.РезультатСравненияМетодов) Тогда
			Продолжить;
		КонецЕсли;
		
		ПутьКМетаданным = ОбработанныйПутьКМетаданным(Строка.ФайлРасширения);
		ДобавитьЭлементыВДерево(Дерево.Строки, ПутьКМетаданным, Строка);
	КонецЦикла; 
	ЗаполнитьКартинкиДерева(Дерево.Строки, Неопределено);
	ЗначениеВРеквизитФормы(Дерево, "ДеревоРазбора");
	
КонецПроцедуры

&НаСервере
Функция ОбработанныйПутьКМетаданным(Путь)
	Результат = СтрЗаменить(Путь, ФайлыРасширения, "");
	Результат = СтрЗаменить(Результат, "Ext\Form\Module.bsl", ""); // модуль формы
	Результат = СтрЗаменить(Результат, "\Ext\Module.bsl", ""); // общие модули
	Шаблон = "%1\";
	Для каждого Пара Из СоответствиеРусскихИАнглийскихИмен Цикл
		ЧтоИщем = СтрШаблон(Шаблон, Пара.Ключ);
		ЧтоПодставляем = СтрШаблон(Шаблон, Пара.Значение);
		Результат = СтрЗаменить(Результат, ЧтоИщем, ЧтоПодставляем);
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Функция СоответствиеРусскихИАнглийскихИмен()
	Результат = Новый Соответствие;
	
	// Виды объектов метаданных (во множественном числе).
	Результат.Вставить("AccountingRegisters", "Регистры бухгалтерии");
	Результат.Вставить("AccumulationRegisters", "Регистры накопления");
	Результат.Вставить("BusinessProcesses", "Бизнес процесс");
	Результат.Вставить("CalculationRegisters", "Регистры расчета");
	Результат.Вставить("Catalogs", "Справочники");
	Результат.Вставить("ChartsOfAccounts", "Планы счетов");
	Результат.Вставить("ChartsOfCalculationTypes", "План видов расчета");
	Результат.Вставить("ChartsOfCharacteristicTypes", "Планы видов характеристик");
	Результат.Вставить("CommonCommands", "Общие команды");
	Результат.Вставить("CommonForms", "Общие формы");
	Результат.Вставить("CommonModules", "Общие модули");
	Результат.Вставить("Constants", "Константы");
	Результат.Вставить("DataProcessors", "Обработки");
	Результат.Вставить("Documents", "Документы");
	Результат.Вставить("DocumentJournals", "Журналы документов");
	Результат.Вставить("Enums", "Перечисления");
	Результат.Вставить("ExchangePlans", "Планы обмена");
	Результат.Вставить("InformationRegisters", "Регистры сведений");
	Результат.Вставить("Reports", "Отчеты");
	Результат.Вставить("Tasks", "Задачи");
	Результат.Вставить("WebServices", "Web сервисы");
	
	Результат.Вставить("Forms", "Формы");
	
	Возврат Результат;
КонецФункции

Процедура ЗаполнитьКартинкиДерева(СтрокиДерева, КартинкаВладельца)
	Для каждого Строка Из СтрокиДерева Цикл  
		Если ЗначениеЗаполнено(Строка.Картинка) Тогда
			Продолжить;
		КонецЕсли;
		КартинкаПоИмени = КартинкаПоИмени(Строка.Имя);
		Если КартинкаПоИмени.Картинка <> Неопределено Тогда
			Строка.Картинка = КартинкаПоИмени.Картинка;
		Иначе
			Строка.Картинка = КартинкаВладельца;
		КонецЕсли;
		Если Строка.Строки.Количество() > 0 Тогда  
			Если ЗначениеЗаполнено(КартинкаПоИмени.КартинкаПодчиненных) Тогда
				ЗаполнитьКартинкиДерева(Строка.Строки, КартинкаПоИмени.КартинкаПодчиненных);		
			Иначе
				ЗаполнитьКартинкиДерева(Строка.Строки, Строка.Картинка);	
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры 

// BSLLS:CognitiveComplexity-off  
// BSLLS:CyclomaticComplexity-off 

Функция КартинкаПоИмени(Имя)   
	
	Результат = Новый Структура;
	Результат.Вставить("КартинкаПодчиненных", Неопределено);
	Если  Имя = "Справочники" Тогда
		Результат.Вставить("Картинка", БиблиотекаКартинок.Справочник);
	ИначеЕсли  Имя = "Формы" Тогда
		Результат.Вставить("Картинка", БиблиотекаКартинок.Форма);
		Результат.Вставить("КартинкаПодчиненных", БиблиотекаКартинок.РежимПросмотраСпискаСписок);
	ИначеЕсли  Имя = "Общие модули" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.РежимПросмотраСпискаСписок);    
	ИначеЕсли  Имя = "Регистры бухгалтерии" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.РегистрБухгалтерии);
	ИначеЕсли  Имя = "Регистры накопления" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.РегистрНакопления);	
	ИначеЕсли  Имя = "Бизнес процесс" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.БизнесПроцесс);	
	ИначеЕсли  Имя = "Регистры расчета" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.РегистрРасчета);	
	ИначеЕсли  Имя = "Планы счетов" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.ПланСчетов);	
	ИначеЕсли  Имя = "План видов расчета" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.ПланВидовРасчета);	
	ИначеЕсли  Имя = "Планы видов характеристик" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.ПланВидовХарактеристик);	
	ИначеЕсли  Имя = "Общие формы" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.Форма);		
	ИначеЕсли  Имя = "Константы" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.Константа);	
	ИначеЕсли  Имя = "Обработки" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.Обработка);
	ИначеЕсли  Имя = "Документы" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.Документ);	
	ИначеЕсли  Имя = "Журналы документов" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.ЖурналДокументов);
	ИначеЕсли  Имя = "Перечисления" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.Перечисление);	
	ИначеЕсли  Имя = "Планы обмена" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.ПланОбмена);	
	ИначеЕсли  Имя = "Регистры сведений" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.РегистрСведений);	
	ИначеЕсли  Имя = "Отчеты" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.Отчет);
	ИначеЕсли  Имя = "Задачи" Тогда   
		Результат.Вставить("Картинка", БиблиотекаКартинок.Задача);	
	Иначе
		Результат.Вставить("Картинка", Неопределено);
	КонецЕсли;
	
	Результат.Вставить("Tasks", "Задачи");
	Результат.Вставить("WebServices", "Web сервисы");

	Возврат Результат;
	
КонецФункции     
 // BSLLS:CognitiveComplexity-on 
 // BSLLS:CyclomaticComplexity-on   
 
&НаСервере
Процедура ДобавитьЭлементыВДерево(Знач СтрокиУровня, ПутьКМетаданным, СтрокаПроблемы)
	ЧастиИмени = СтрРазделить(ПутьКМетаданным, "\", Ложь);
	Для каждого ЧастьИмени Из ЧастиИмени Цикл
		ИскомыйЭлемент = СтрокиУровня.Найти(ЧастьИмени, "Имя");
		Если ИскомыйЭлемент = Неопределено Тогда
			ИскомыйЭлемент = СтрокиУровня.Добавить();
			ИскомыйЭлемент.Имя = ЧастьИмени;
		КонецЕсли;
		СтрокиУровня = ИскомыйЭлемент.Строки;
	КонецЦикла;
	СтрокаСМетодом = ИскомыйЭлемент.Строки.Добавить();
	СтрокаСМетодом.Проблема = СтрокаПроблемы.РезультатСравненияМетодов;  
	СтрокаСМетодом.Имя = СтрокаПроблемы.ПереопределяемыйМетод;  
	СтрокаСМетодом.Картинка = БиблиотекаКартинок.ДиалогВосклицание;
	СтрокаСМетодом.Аннотация = ОбработаннаяАннотация(СтрокаПроблемы.Аннотация); 
	СтрокаСМетодом.ИДСтроки = СтрокаПроблемы.ИдСтроки;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево()
	Для Каждого Строка Из ДеревоРазбора.ПолучитьЭлементы() Цикл
		Элементы.ДеревоРазбора.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ОбработаннаяАннотация(Имя)
	Если Имя = "After" Тогда
		Возврат "Перед";
	ИначеЕсли Имя = "Before" Тогда
		Возврат "После";
	ИначеЕсли Имя = "Override" Тогда
		Возврат "Вместо";	
	Иначе 	
		Возврат Имя;
	КонецЕсли;
		
КонецФункции

&НаКлиенте
Процедура ДеревоРазбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	 СтрокаПредставления = ДеревоРазбора.НайтиПоИдентификатору(ВыбраннаяСтрока); 
	 Если НЕ ЗначениеЗаполнено(СтрокаПредставления.ИДСтроки) Тогда
	 	 Возврат;
	 КонецЕсли;
	 Отбор = Новый Структура("ИДСтроки", СтрокаПредставления.ИДСтроки);
	 НайденныеСтроки = РезультатыРазбора.НайтиСтроки(Отбор);
	 СтрокаРазбора = НайденныеСтроки[0];   
	 ПоказатьОтличия(СтрокаРазбора);
КонецПроцедуры     

&НаКлиенте
Процедура ПоказатьОтличия(СтрокаРазбора) 
	ЗначенияПараметров =  Новый Структура;    
	Если СтрокаРазбора.РезультатСравненияМетодов = "Метод отсутствует в новой конфигурации" Тогда
		СравнениеТрехФайлов = Ложь;
		ПараметрыКоманднойСтроки = ПараметрыКоманднойСтроки2Файла;
	Иначе
		СравнениеТрехФайлов = Истина;
		ПараметрыКоманднойСтроки = ПараметрыКоманднойСтроки3Файла;
	КонецЕсли;

	ИмяОсновная = ПолучитьИмяВременногоФайла("txt");
	ИмяРасширение = ПолучитьИмяВременногоФайла("txt");  	
	ЗначенияПараметров.Вставить("СтараяКонфигурация", ИмяОсновная);
	ЗначенияПараметров.Вставить("Расширение", ИмяРасширение);
	СоздатьФайлСМетодом(ИмяОсновная, СтрокаРазбора.МетодОсновнаяКонфигурация);	
	СоздатьФайлСМетодом(ИмяРасширение, СтрокаРазбора.МетодРасширение);
	
	Если СравнениеТрехФайлов Тогда      
		// BSLLS:MissingTemporaryFileDeletion-off
		ИмяНовая = ПолучитьИмяВременногоФайла("txt"); 
		// BSLLS:MissingTemporaryFileDeletion-on
		ЗначенияПараметров.Вставить("НоваяКонфигурация", ИмяНовая);
		СоздатьФайлСМетодом(ИмяНовая, СтрокаРазбора.МетодНоваяКонфигурация);
	КонецЕсли;
	
	СтрокаПараметровПриложения = ЗаменаПоШаблону(ПараметрыКоманднойСтроки, ЗначенияПараметров);
		
	СтрокаЗапуска = ПутьКПрограммеСравнения + " " + СтрокаПараметровПриложения; 
	ЗапуститьПриложение(СтрокаЗапуска, , Истина);
	
	УдалитьФайлы(ИмяОсновная);  
	УдалитьФайлы(ИмяРасширение);
	
	Если СравнениеТрехФайлов Тогда
		УдалитьФайлы(ИмяНовая); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаменаПоШаблону(ПараметрыКоманднойСтроки, ЗначенияПараметров)
	ЗначенияПараметров.Вставить("ЗаголовокСтарая", "Старая_конфигурация");
	ЗначенияПараметров.Вставить("ЗаголовокРасширение", "Расширение"); 
	Если ЗначенияПараметров.Свойство("НоваяКонфигурация") 
		И ЗначениеЗаполнено(ЗначенияПараметров.НоваяКонфигурация) Тогда
		ЗначенияПараметров.Вставить("ЗаголовокНовая", "Новая_конфигурация");	
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ПараметрыКоманднойСтроки, ЗначенияПараметров);
КонецФункции

&НаКлиенте
Процедура СоздатьФайлСМетодом(ИмяФайла, Метод)
	ТекстовыйФайл = Новый ТекстовыйДокумент;
	ТекстовыйФайл.ДобавитьСтроку(Метод.ШапкаМетода);
	ТекстовыйФайл.ДобавитьСтроку(Метод.ТелоМетода);
	ТекстовыйФайл.ДобавитьСтроку(Метод.ЗавершениеМетода);
	ТекстовыйФайл.Записать(ИмяФайла);
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеСравненияПриИзменении(Элемент)
	// BSLLS:LineLength-off
	Если СтрНайти(ПутьКПрограммеСравнения, "kdiff") > 0 Тогда   
		ПараметрыКоманднойСтроки3Файла = "[СтараяКонфигурация] [Расширение] [НоваяКонфигурация] -m --L1 [ЗаголовокСтарая] --L2 [ЗаголовокРасширение] --L3 [ЗаголовокНовая]"; 
		ПараметрыКоманднойСтроки2Файла = "[СтараяКонфигурация] [Расширение]  --L1 [ЗаголовокСтарая] --L2 [ЗаголовокРасширение]"; 
		ПоказатьПредупреждение(, "Автоматически подставились параметры командной строки для KDiff3");
	КонецЕсли;
	Если СтрНайти(ПутьКПрограммеСравнения, "p4merge") > 0 Тогда
		ПараметрыКоманднойСтроки3Файла = "-C utf8-bom -dw -nb [ЗаголовокСтарая] -nl [ЗаголовокРасширение] -nr [ЗаголовокНовая] [СтараяКонфигурация] [Расширение] [НоваяКонфигурация] ";  
		ПараметрыКоманднойСтроки2Файла = "-C utf8-bom -dw -nl [ЗаголовокСтарая] -nr [ЗаголовокРасширение]  [СтараяКонфигурация] [Расширение]";  
		ПоказатьПредупреждение(, "Автоматически подставились параметры командной строки для P4Merge");
	КонецЕсли;             
	// BSLLS:LineLength-on
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРазбораОтметкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДеревоРазбора.ТекущиеДанные;
	СерыйФлаг = 2;
	Если ТекущиеДанные.Отметка = СерыйФлаг Тогда
		ТекущиеДанные.Отметка = 0;
	КонецЕсли;  
	ОбновитьПодчиненныеФлажки(ТекущиеДанные, ТекущиеДанные.Отметка);
	ОбновитьРодительскиеФлажки(ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПодчиненныеФлажки(ТекущиеДанные, Значение) 
	ПодчиненныеСтроки = ТекущиеДанные.ПолучитьЭлементы();
	Для Каждого Строка Из ПодчиненныеСтроки Цикл
		Строка.Отметка = Значение;
		ОбновитьПодчиненныеФлажки(Строка, Строка.Отметка);
	КонецЦикла;
КонецПроцедуры   

&НаКлиенте
Процедура ОбновитьРодительскиеФлажки(ТекущиеДанные) 
	Родитель = ТекущиеДанные.ПолучитьРодителя(); 
	Пока Родитель <> Неопределено Цикл    
		ВсеФлагиОдинаковы = ВсеФлагиОдинаковы(ТекущиеДанные);  
		Если ВсеФлагиОдинаковы Тогда
			Родитель.Отметка = ТекущиеДанные.Отметка;
		Иначе
			Родитель.Отметка = 2;
		КонецЕсли;
		Родитель = Родитель.ПолучитьРодителя();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ВсеФлагиОдинаковы(ТекущиеДанные)         
	ЭлементыТекущегоУровня = ТекущиеДанные.ПолучитьРодителя().ПолучитьЭлементы();
	Для Каждого Строка Из ЭлементыТекущегоУровня Цикл
		Если Строка.Отметка <> ТекущиеДанные.Отметка Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции    

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)    
	Обработка = РеквизитФормыВЗначение("Объект");     
	Заголовок = Обработка.Метаданные().Синоним + ". Версия: " + Обработка.ВерсияОбработки();
	
КонецПроцедуры
#КонецОбласти