﻿&НаКлиенте
&НаКлиенте
&НаКлиенте
Процедура ПослеКаждогоТеста () Экспорт
    ОчиститьДанныеТестов();
КонецПроцедуры

Процедура ИсполняемыеСценарии() Экспорт     
     ЮТТесты
	 	.После("ОчиститьДанныеТестов")
    	.ДобавитьКлиентскийТест("ДетекцияДвойныхИзменений") 
		.ДобавитьКлиентскийТест("ДетекцияОтсутствияДвойныхИзменений")
		.ДобавитьКлиентскийТест("Автообъединение")
		.ДобавитьКлиентскийТест("ИзмененияТолькоВРасширении");
			
КонецПроцедуры

&НаКлиенте
Процедура ДетекцияДвойныхИзменений() Экспорт   
	Результат = РезультатОткрытияОбработки("Все аннотации с изменениями");
	ЮТест.ОжидаетЧто(Результат.количество(), "Количество измененных методов").Равно(4); 
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("Аннотация", "Вместо");
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("Аннотация", "Перед");
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("Аннотация", "После");
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("Аннотация", "ИзменениеИКонтроль");
	ЮТест.ОжидаетЧто(Результат).КаждыйЭлементСодержитСвойствоСоЗначением("РезультатСравненияМетодов", "Отличаются тексты методов");
КонецПроцедуры  

&НаКлиенте
Процедура ДетекцияОтсутствияДвойныхИзменений() Экспорт   
	Результат = РезультатОткрытияОбработки("Все аннотации без изменений");
	ЮТест.ОжидаетЧто(Результат.количество(), "Количество измененных методов").Равно(4);
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("Аннотация", "Вместо");
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("Аннотация", "Перед");
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("Аннотация", "После"); 
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("Аннотация", "ИзменениеИКонтроль");
	ЮТест.ОжидаетЧто(Результат).КаждыйЭлементСодержитСвойствоСоЗначением("РезультатСравненияМетодов", "");
КонецПроцедуры 

&НаКлиенте
Процедура Автообъединение() Экспорт   
	Результат = РезультатОткрытияОбработки("Автообъединение");
	ЮТест.ОжидаетЧто(Результат.количество(), "Количество измененных методов").Равно(1); 
	РезультатОбъединения ="&ИзменениеИКонтроль(""ТоварыТСД"")
	|Функция Рас_ТоварыТСД(ДанныеЗагрузки, АлкогольнаяПродукция)
	|	АлкогольнаяПродукция = Ложь;
	|	Результат = Новый Массив();
	|	#Удаление
	|	ПозицияДанных.Вставить(""Количество"", ЧтениеXML.ЗначениеАтрибута(""Quantity""));
	|	#КонецУдаления	                                                              
	|	#Вставка
	|	Если ЧтениеXML.ЗначениеАтрибута(""Quantity"")=Неопределено Тогда                      
	|		ПозицияДанных.Вставить(""Количество"", 1);   
	|	КонецЕсли;
	|	#КонецВставки
	|	Возврат Результат;
	|
	|КонецФункции";
    
	ПутьКФайлу = ПутьКОбработке() + "\tmp\CommonModules\Test\Module.bsl";
	СодержимоеФайла = СодержимоеФайла(ПутьКФайлу); 
	ЮТест.ОжидаетЧто(СодержимоеФайла).Равно(РезультатОбъединения); 
КонецПроцедуры 

&НаКлиенте
Процедура ИзмененияТолькоВРасширении() Экспорт   
	Результат = РезультатОткрытияОбработки("Изменения только в расширении");
	ЮТест.ОжидаетЧто(Результат.количество(), "Количество измененных методов").Равно(2); 
	ЮТест.ОжидаетЧто(Результат).КаждыйЭлементСодержитСвойствоСоЗначением("Аннотация", "ИзменениеИКонтроль");
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("РезультатСравненияМетодов", "");
	ЮТест.ОжидаетЧто(Результат).ЛюбойЭлементСодержитСвойствоСоЗначением("РезультатСравненияМетодов",
		"Методы конфигураций идентичны,но метод расширения отличается от метода в конфигурации");
КонецПроцедуры 

&НаКлиенте
Процедура ОчиститьДанныеТестов() Экспорт   
	ПутьКОбработке = ПутьКОбработке();
 	ВременныйКаталог = ПутьКОбработке + "\tmp\";
    УдалитьФайлы(ВременныйКаталог, "*.*");
КонецПроцедуры

&НаКлиенте
Функция РезультатОткрытияОбработки(ПутьКТестам) Экспорт
		
		ПараметрыВызоваТест = Новый Структура;
		ПараметрыВызоваТест.Вставить("Объект", ПараметрыОбъектаПоУмолчанию());
		ПараметрыВызоваТест.Вставить("ЭтотОбъект", ПараметрыФормы(ПутьКТестам));
		
		ПараметрыОткрытия = Новый Структура; 
		ПараметрыОткрытия.Вставить("ПараметрыВызоваТест", ПараметрыВызоваТест);
		ПараметрыОткрытия.Вставить("ЗапуститьАнализПриОткрытии", Истина);  
		ПараметрыОткрытия.Вставить("ИспользоватьМодальныйРежим", Истина);  
				
		
        АдресХранилища = "";
		Результат = ПоместитьФайл(АдресХранилища, ПутьКОбработке() + "CfeUpdater.epf", , Ложь);           
		ИмяОбработки = ОМ_СлужебныйВызовСервера.ПодключитьВнешнююОбработку(АдресХранилища);
		Результат = ОткрытьФормуМодально("ВнешняяОбработка." + ИмяОбработки + ".Форма", ПараметрыОткрытия);  
//		Результат = ОткрытьФормуМодально("Обработка.АнализРасширенияПриОбновлении.Форма.Форма", ПараметрыОткрытия);  
		Возврат Результат;				
	
КонецФункции

Функция ПараметрыФормы(ПутьКТестам)    
	Результат = Новый Структура;       
	ПутьКОбработке = ПутьКОбработке();
 	ПутьКТестам  = ПутьКОбработке + "Tests\" + ПутьКТестам + "\";  
	ВременныйКаталог = ПутьКОбработке + "\tmp\";
	СоздатьКаталог(ВременныйКаталог); 
	Результат.Вставить("ФайлыНовойКонфигурации", ПутьКТестам + "Новая конфигурация\");
	Результат.Вставить("ФайлыОбновляемойКонфигурации", ПутьКТестам + "Старая конфигурация\");
	Результат.Вставить("ФайлыРасширения", ПутьКТестам + "Расширение\");
	Результат.Вставить("КаталогСРезультатами", ВременныйКаталог);   
	Результат.Вставить("ЗапуститьАнализПриОткрытии", Истина);
	Возврат Результат;	
КонецФункции

Функция ПараметрыОбъектаПоУмолчанию()  
	Результат = Новый Структура;
	Результат.Вставить("ПрограммаПросмотраИзменений", "KDiff3");
	Результат.Вставить("ПутьКGitMerge", "C:\Program Files\Git\bin\git.exe");
	Результат.Вставить("ПутьДоKDiff3", "C:\Program Files\KDiff3\bin\kdiff3.exe");
	Результат.Вставить("ПутьДоP4Merge", "C:\Program Files\Perforce\p4merge.exe");
	Результат.Вставить("ПараметрыКоманднойСтроки2ФайлаKDiff3", 
		"[СтараяКонфигурация] [Расширение]  --L1 [ЗаголовокСтарая] --L2 [ЗаголовокРасширение]");
	Результат.Вставить("ПараметрыКоманднойСтроки2ФайлаP4Merge", 
		"-C utf8-bom -dw -nl [ЗаголовокСтарая] -nr [ЗаголовокРасширение]  [СтараяКонфигурация] [Расширение]");
	Результат.Вставить("ПараметрыКоманднойСтроки3ФайлаKDiff3", 
		"[СтараяКонфигурация] [Расширение] [НоваяКонфигурация] -m --L1 [ЗаголовокСтарая] --L2 [ЗаголовокРасширение] --L3 [ЗаголовокНовая]");
	Результат.Вставить("ПараметрыКоманднойСтроки3ФайлаP4Merge", 
		"-C utf8-bom -dw -nb [ЗаголовокСтарая] -nl [ЗаголовокРасширение] -nr [ЗаголовокНовая] [СтараяКонфигурация] [Расширение] [НоваяКонфигурация] ");
	Возврат Результат;	
КонецФункции

Функция ПутьКОбработке()
	Возврат "D:\1C\CfeUpdater\";	
КонецФункции

&НаКлиенте
Функция СодержимоеФайла(ИмяФайла)
	ТекстовыйФайл = Новый ТекстовыйДокумент;
	ТекстовыйФайл.Прочитать(ИмяФайла);
	Возврат ТекстовыйФайл.ПолучитьТекст();
КонецФункции // ()


