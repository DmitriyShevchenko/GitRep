﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти
#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка" Тогда
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("ПоказатьСтраницуПрограммы");
		ВыбраннаяФорма = Метаданные.ОбщиеФормы.НастройкиЭлектроннойПодписиИШифрования;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область СлужебныеПроцедурыИФункции

Функция ПоставляемыеНастройкиПрограмм() Экспорт
	
	Настройки = Новый ТаблицаЗначений;
	Настройки.Колонки.Добавить("Представление");
	Настройки.Колонки.Добавить("ИмяПрограммы");
	Настройки.Колонки.Добавить("ТипПрограммы");
	Настройки.Колонки.Добавить("АлгоритмПодписи");
	Настройки.Колонки.Добавить("АлгоритмХеширования");
	Настройки.Колонки.Добавить("АлгоритмШифрования");
	Настройки.Колонки.Добавить("Идентификатор");
	
	Настройки.Колонки.Добавить("АлгоритмыПодписи",     Новый ОписаниеТипов("Массив"));
	Настройки.Колонки.Добавить("АлгоритмыХеширования", Новый ОписаниеТипов("Массив"));
	Настройки.Колонки.Добавить("АлгоритмыШифрования",  Новый ОписаниеТипов("Массив"));
	
	// ViPNet CSP
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'ViPNet CSP'");
	Настройка.ИмяПрограммы        = "Infotecs Cryptographic Service Provider";
	Настройка.ТипПрограммы        = 2;
	// Варианты: GOST R 34.10-2001, GOST 34.10-2012 256, GOST 34.11-2012 512.
	Настройка.АлгоритмПодписи     = "GOST R 34.10-2001";
	// Варианты: GOST R 34.11-94,   GOST 34.11-2012 256, GOST 34.11-2012 512.
	Настройка.АлгоритмХеширования = "GOST R 34.11-94";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";     // Один вариант.
	Настройка.Идентификатор       = "VipNet";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыПодписи.Добавить("GOST 34.10-2012 256");
	Настройка.АлгоритмыПодписи.Добавить("GOST 34.10-2012 512");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыХеширования.Добавить("GOST 34.11-2012 256");
	Настройка.АлгоритмыХеширования.Добавить("GOST 34.11-2012 512");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	
	// КриптоПро CSP
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'КриптоПро CSP'");
	Настройка.ИмяПрограммы        = "Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider";
	Настройка.ТипПрограммы        = 75;
	Настройка.АлгоритмПодписи     = "GOST R 34.10-2001";
	Настройка.АлгоритмХеширования = "GOST R 34.11-94";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "CryptoPro";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	
	// ЛИССИ CSP
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'ЛИССИ CSP'");
	Настройка.ИмяПрограммы        = "LISSI-CSP";
	Настройка.ТипПрограммы        = 75;
	Настройка.АлгоритмПодписи     = "GOST R 34.10-2001";
	Настройка.АлгоритмХеширования = "GOST R 34.11-94";
	Настройка.АлгоритмШифрования  = "GOST 28147-89";
	Настройка.Идентификатор       = "Lissi";
	
	Настройка.АлгоритмыПодписи.Добавить("GOST R 34.10-2001");
	Настройка.АлгоритмыХеширования.Добавить("GOST R 34.11-94");
	Настройка.АлгоритмыШифрования.Добавить("GOST 28147-89");
	
	// Сигнал-КОМ CSP (RFC 4357)
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'Сигнал-КОМ CSP (RFC 4357)'");
	Настройка.ИмяПрограммы        = "Signal-COM CPGOST Cryptographic Provider";
	Настройка.ТипПрограммы        = 75;
	Настройка.АлгоритмПодписи     = "ECR3410-CP";
	Настройка.АлгоритмХеширования = "RUS-HASH-CP";
	Настройка.АлгоритмШифрования  = "GOST28147";
	Настройка.Идентификатор       = "SignalComCPGOST";
	
	Настройка.АлгоритмыПодписи.Добавить("ECR3410-CP");
	Настройка.АлгоритмыХеширования.Добавить("RUS-HASH-CP");
	Настройка.АлгоритмыШифрования.Добавить("GOST28147");
	
	// Сигнал-КОМ CSP (ITU-T X.509 v.3).
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'Сигнал-КОМ CSP (ITU-T X.509 v.3)'");
	Настройка.ИмяПрограммы        = "Signal-COM ECGOST Cryptographic Provider";
	Настройка.ТипПрограммы        = 129;
	Настройка.АлгоритмПодписи     = "ECR3410";
	Настройка.АлгоритмХеширования = "RUS-HASH";
	Настройка.АлгоритмШифрования  = "GOST28147";
	Настройка.Идентификатор       = "SignalComECGOST";
	
	Настройка.АлгоритмыПодписи.Добавить("ECR3410");
	Настройка.АлгоритмыХеширования.Добавить("RUS-HASH");
	Настройка.АлгоритмыШифрования.Добавить("GOST28147");
	
	// Microsoft Enhanced CSP
	Настройка = Настройки.Добавить();
	Настройка.Представление       = НСтр("ru = 'Microsoft Enhanced CSP'");
	Настройка.ИмяПрограммы        = "Microsoft Enhanced Cryptographic Provider v1.0";
	Настройка.ТипПрограммы        = 1;
	Настройка.АлгоритмПодписи     = "RSA_SIGN"; // Один вариант.
	Настройка.АлгоритмХеширования = "MD5";      // Варианты: SHA-1, MD2, MD4, MD5.
	Настройка.АлгоритмШифрования  = "RC2";      // Варианты: RC2, RC4, DES, 3DES.
	Настройка.Идентификатор       = "MicrosoftEnhanced";
	
	Настройка.АлгоритмыПодписи.Добавить("RSA_SIGN");
	Настройка.АлгоритмыХеширования.Добавить("SHA-1");
	Настройка.АлгоритмыХеширования.Добавить("MD2");
	Настройка.АлгоритмыХеширования.Добавить("MD4");
	Настройка.АлгоритмыХеширования.Добавить("MD5");
	Настройка.АлгоритмыШифрования.Добавить("RC2");
	Настройка.АлгоритмыШифрования.Добавить("RC4");
	Настройка.АлгоритмыШифрования.Добавить("DES");
	Настройка.АлгоритмыШифрования.Добавить("3DES");
	
	Возврат Настройки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ОписаниеПрограмм = Новый Массив;
	
	ОписаниеПрограмм.Добавить(ЭлектроннаяПодпись.НовоеОписаниеПрограммы(
		"Infotecs Cryptographic Service Provider", 2));
	
	ОписаниеПрограмм.Добавить(ЭлектроннаяПодпись.НовоеОписаниеПрограммы(
		"Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider", 75));
	
	ЭлектроннаяПодпись.ЗаполнитьСписокПрограмм(ОписаниеПрограмм);
	
КонецПроцедуры

#КонецОбласти
#КонецЕсли
