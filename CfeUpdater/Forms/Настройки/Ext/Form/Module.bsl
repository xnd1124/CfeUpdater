﻿
// BSLLS:LatinAndCyrillicSymbolInWord-off

&НаКлиенте
Процедура ПерейтиКАнализуИзменений(Команда)
	НастройкиСравнения = НастройкиСравнения();
	ЗаполнитьЗначенияСвойств(НастройкиСравнения, Объект);
	ЭтотОбъект.Закрыть(НастройкиСравнения);
КонецПроцедуры

Функция ЭтотОбъект()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

Функция НастройкиСравнения()
	Возврат ЭтотОбъект().НастройкиСравнения();
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
КонецПроцедуры

&НаКлиенте
Процедура ПрограммаПросмотраИзмененийПриИзменении(Элемент)
	ПроверитьПутьКПрограмме();  
	ОбновитьПодписиНастроекПрограммПросмотра();
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПутьКПрограмме()
	ПутьДоПрограммы = ПутьДоПрограммы();
	Если  ПутьДоПрограммы = "" Тогда
		Возврат;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект[ПутьДоПрограммы]) Тогда
		ПутьПоУмолчанию = ПутьПоУмолчанию();  
		Если ФайлСуществует(ПутьПоУмолчанию) Тогда
			Объект[ПутьДоПрограммы] = ПутьПоУмолчанию;	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПутьДоПрограммы()    
	Если ЗначениеЗаполнено(Объект.ПрограммаПросмотраИзменений) Тогда
		Возврат "ПутьДо" + Объект.ПрограммаПросмотраИзменений;	
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ПутьПоУмолчанию()   
	// BSLLS:UsingHardcodePath-off
	Если ЭтоKDiff3() Тогда
		Возврат "C:\Program Files\KDiff3\bin\kdiff3.exe";
	ИначеЕсли ЭтоP4Merge() Тогда
		Возврат "C:\Program Files\Perforce\p4merge.exe"; 
	Иначе
		ВызватьИсключение "Не предусмотренная настройка программы";	
	КонецЕсли;
	// BSLLS:UsingHardcodePath-on
КонецФункции

&НаКлиенте
Функция ЭтоKDiff3()
	Возврат Объект.ПрограммаПросмотраИзменений = "KDiff3";
КонецФункции

&НаКлиенте
Функция ЭтоP4Merge()
	Возврат Объект.ПрограммаПросмотраИзменений = "P4Merge";
КонецФункции  

&НаКлиенте
Функция ФайлСуществует(ПолноеИмяФайла)
	Файл = Новый Файл(ПолноеИмяФайла);
	Возврат Файл.Существует();
КонецФункции

&НаКлиенте
Процедура ОбновитьПодписиНастроекПрограммПросмотра()
	ПутьДоПрограммы = ПутьДоПрограммы();
	Если ПутьДоПрограммы = ""
		ИЛИ НЕ ЗначениеЗаполнено(Объект[ПутьДоПрограммы]) Тогда  
		ПоказываемыйЭлемент = Элементы.ПутьНеНайден;
		НевидимыйЭлемент = Элементы.ПутьКорректен;
		ПоказываемыйЭлемент.Заголовок = "Путь не указан, выберите программу";  
	ИначеЕсли ФайлСуществует(Объект[ПутьДоПрограммы]) Тогда
		ПоказываемыйЭлемент = Элементы.ПутьКорректен;
		НевидимыйЭлемент = Элементы.ПутьНеНайден;
		ПоказываемыйЭлемент.Заголовок = Объект[ПутьДоПрограммы] + ". Файл найден. Нажмите для настройки"; 
	Иначе
		ПоказываемыйЭлемент = Элементы.ПутьНеНайден;
		НевидимыйЭлемент = Элементы.ПутьКорректен;
		ПоказываемыйЭлемент.Заголовок = Объект[ПутьДоПрограммы] + ". Файл не найден. Нажмите для настройки"; 
	КонецЕсли;
	
	ПоказываемыйЭлемент.Видимость = Истина;
	НевидимыйЭлемент.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПодписиКПрограммеАвтоСлияния()
	ПутьДоПрограммы = Объект.ПутьКGitMerge;
	Если Не ЗначениеЗаполнено(СокрЛП(ПутьДоПрограммы)) Тогда  
		ПоказываемыйЭлемент = Элементы.ФайлОтсутсвует;
		НевидимыйЭлемент = Элементы.ФайлНайден;
		ПоказываемыйЭлемент.Заголовок = "Путь не указан, автоматическое слияние не применяется";  
	ИначеЕсли ФайлСуществует(ПутьДоПрограммы) Тогда
		ПоказываемыйЭлемент = Элементы.ФайлНайден;
		НевидимыйЭлемент = Элементы.ФайлОтсутсвует;
		ПоказываемыйЭлемент.Заголовок = "Файл найден"; 
	Иначе
		ПоказываемыйЭлемент = Элементы.ФайлОтсутсвует;
		НевидимыйЭлемент = Элементы.ФайлНайден;
		ПоказываемыйЭлемент.Заголовок = "Файл не найден, автоматическое слияние не применяется"; 
	КонецЕсли;
	
	ПоказываемыйЭлемент.Видимость = Истина;
	НевидимыйЭлемент.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)  
	ЭтотОбъект.РазделительНаКлиенте = ПолучитьРазделительПути();

	ОбновитьПодписиНастроекПрограммПросмотра();
	ОбновитьПодписиКПрограммеАвтоСлияния();
КонецПроцедуры

&НаКлиенте
Процедура ПутьКGitMergeНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие); 
	ДиалогВыбораФайла.Каталог = КаталогИзПолногоПутиФайла(Объект.ПутьКGitMerge);
	Если ОбщегоНазначенияКлиент.ЭтоLinuxКлиент() = Ложь Тогда
		ДиалогВыбораФайла.Фильтр = "Исполняемые файлы| *.exe";
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораФайлаАвтоСлияния", ЭтотОбъект);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
КонецПроцедуры

Функция КаталогИзПолногоПутиФайла(ПутьКФайлу)
	Если Не ЗначениеЗаполнено(ПутьКФайлу) Тогда
		Возврат ПутьКФайлу; 
	КонецЕсли;
	ЧастиФайла = СтрРазделить(ПутьКфайлу, РазделительНаКлиенте); 
	Если ЧастиФайла.Количество() = 0  Тогда
		Возврат ПутьКФайлу; 	
	КонецЕсли;	
	ИндексПоследнего = ЧастиФайла.ВГраница();
	ЧастиФайла[ИндексПоследнего] = "";
	Возврат СтрСоединить(ЧастиФайла, РазделительНаКлиенте);
КонецФункции

&НаКлиенте
Процедура ПослеВыбораФайлаАвтоСлияния(Результат, ДопПараметры) Экспорт
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	Объект.ПутьКGitMerge = Результат[0];   
	ОбновитьПодписиКПрограммеАвтоСлияния();
КонецПроцедуры

&НаКлиенте
Процедура ПутьКGitMergeПриИзменении(Элемент)
	ОбновитьПодписиКПрограммеАвтоСлияния();
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПрограммеНажатие(Элемент)     
	Если Объект.ПрограммаПросмотраИзменений = "" Тогда
		Возврат;
	КонецЕсли;
	НастройкиСравнения = НастройкиСравнения();
	ЗаполнитьЗначенияСвойств(НастройкиСравнения, Объект);   
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОткрытияНастроек", ЭтотОбъект);
	ОткрытьФорму("ВнешняяОбработка.АнализРасширенияПриОбновлении.Форма.НастройкиПрограммСравнения", 
		НастройкиСравнения, , , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияНастроек(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Объект, Результат); 	
		ОбновитьПодписиНастроекПрограммПросмотра();
	КонецЕсли;
КонецПроцедуры
