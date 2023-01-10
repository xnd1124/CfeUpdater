﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////
 
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
 
#Область ПрограммныйИнтерфейс
 
// Возвращает сведения о внешней обработке.
//
// Возвращаемое значение:
//   Структура - Подробнее см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке().
//
Функция СведенияОВнешнейОбработке() Экспорт
  // BSLLS:UsingHardcodeNetworkAddress-off
   ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("3.1.7.190");
   // BSLLS:UsingHardcodeNetworkAddress-off
   
   ПараметрыРегистрации.Информация = НСтр("ru = '" + Метаданные().Синоним + "'");
   ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
   ПараметрыРегистрации.Версия = ВерсияОбработки();
   ПараметрыРегистрации.БезопасныйРежим = Истина;
   
   Команда = ПараметрыРегистрации.Команды.Добавить();
   Команда.Представление =  НСтр("ru = '" + Метаданные().Синоним + "'");
   Команда.Идентификатор =  Метаданные().Имя;
   Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
   Команда.ПоказыватьОповещение = Истина;
       
   Возврат ПараметрыРегистрации;
КонецФункции
 
#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции
Функция ВерсияОбработки() Экспорт
  	Возврат "1.0.1.9";	
 КонецФункции
#КонецОбласти

#КонецЕсли
