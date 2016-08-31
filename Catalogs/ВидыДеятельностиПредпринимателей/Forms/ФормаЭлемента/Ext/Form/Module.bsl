﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	ПериодыДвиженийПоВидуДеятельности = УчетДоходовИРасходовПредпринимателя.ПериодыДвиженийПоВидуДеятельности(Объект.Ссылка);
	ЕстьДвиженияПоВидуДеятельности = НЕ ПериодыДвиженийПоВидуДеятельности = Неопределено
		И ПериодыДвиженийПоВидуДеятельности.Количество() > 0;
		
	// Если одна номенклатурная группа, то не показываем табличную часть Номенклатурные группы
	Элементы.НоменклатурныеГруппы.Видимость = НЕ БухгалтерскийУчетВызовСервераПовтИсп.ИспользоватьОднуНоменклатурнуюГруппу();;
	
	ЗаполнитьСписокВыбораХарактеровДеятельности();
	
	УстановитьОтборНоменклатурныхГрупп();
	
	ХарактерДеятельности = Объект.ХарактерДеятельности;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ДобавитьВыбранныеНоменклатурныеГруппы(ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ПериодыДвиженийПоВидуДеятельности = УчетДоходовИРасходовПредпринимателя.ПериодыДвиженийПоВидуДеятельности(Объект.Ссылка);
	ПредупредитьОНеобходимостиПерепроведенияДокументов = Ложь;
	
	МассивПредупреждений = Новый Массив;
	
	Если НЕ ПериодыДвиженийПоВидуДеятельности = Неопределено
		И ПериодыДвиженийПоВидуДеятельности.Количество() > 0 Тогда
		
		СвойстваВидаДеятельности = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущийОбъект.Ссылка,
			"ХарактерДеятельности, НоменклатурнаяГруппа");
		
		ПредупредитьОНеобходимостиПерепроведенияДокументов =
			НЕ СвойстваВидаДеятельности.ХарактерДеятельности = ТекущийОбъект.ХарактерДеятельности
				ИЛИ НЕ СвойстваВидаДеятельности.НоменклатурнаяГруппа = ТекущийОбъект.НоменклатурнаяГруппа;
			
		Если ПредупредитьОНеобходимостиПерепроведенияДокументов Тогда
			
			Для каждого ПериодДвижений Из ПериодыДвиженийПоВидуДеятельности Цикл
				
				ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Рекомендуется перепровести документы организации ""%1"" за период: %2'"),
					ПериодДвижений.Организация,
					ПредставлениеПериода(ПериодДвижений.НачалоПериода, ПериодДвижений.КонецПериода, "ФП = Истина"));
				
				МассивПредупреждений.Добавить(ТекстПредупреждения);
			
			КонецЦикла;
			
		КонецЕсли;
	
	КонецЕсли;

	ПараметрыЗаписи.Вставить("МассивПредупреждений", МассивПредупреждений);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьОтборНоменклатурныхГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Перем МассивПредупреждений;
	
	Если ПредупредитьОНеобходимостиПерепроведенияДокументов Тогда
		
		Если ПараметрыЗаписи.Свойство("МассивПредупреждений", МассивПредупреждений) Тогда
			
			Для каждого ТекстПредупреждения Из МассивПредупреждений Цикл
			
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстПредупреждения);
			
			КонецЦикла;
			
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗаписиЗавершение", ЭтотОбъект);  
		
		ПоказатьПредупреждение(ОписаниеОповещения, НСтр("ru = 'Изменен основной вид деятельности одной из организаций. 
			|Рекомендуется перепровести документы.'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	// Флаг предупреждения сбрасывается в процедуре ПередЗакрытием, а не в обработчике ПослеЗаписиЗавершение,
	// чтобы в обработчике по тому, что флаг сброшен, было понятно, что нужно закрыть форму.
	
	Если ПредупредитьОНеобходимостиПерепроведенияДокументов Тогда
		Отказ = Истина;
		ПредупредитьОНеобходимостиПерепроведенияДокументов = Ложь; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиЗавершение(Результат) Экспорт
	
	// В данный обработчик мы можем попасть и при выполнении команды "Записать", и при выполнении команды "Записать и закрыть".
	// Необходимо, чтобы обработчик по-разному отрабатывал в этих ситуациях,
	// т.е. нам необходимо понять, нужно ли закрывать форму. 
	// Для этого используется следующий прием:
	// т.к. при выполнении команды "Записать и закрыть" в процедуру ПередЗакрытием мы попадаем раньше, 
	// чем в обработчик оповещения, то мы можем сбрасывать флаг предупреждения в ней, а не в обработчике.
	// А в обработчике по тому, что флаг сброшен, мы понимаем, что отработало ПередЗакрытием и нужно закрыть форму.
	
	Если НЕ ПредупредитьОНеобходимостиПерепроведенияДокументов Тогда
		Закрыть();
	Иначе
		ПредупредитьОНеобходимостиПерепроведенияДокументов = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Перем НоменклатурнаяГруппа;
	
	// Если используется одна номенклатурная группа, то здесь не проверяем,
	// установим номенклатурную группу при записи
	Если БухгалтерскийУчетВызовСервераПовтИсп.ИспользоватьОднуНоменклатурнуюГруппу() Тогда
		Возврат;
	КонецЕсли;
	
	НоменклатурнаяГруппа = РегистрыСведений.ВидыДеятельностиПредпринимателей.ПолучитьПервуюНоменклатурнуюГруппу(Объект.Ссылка, Объект.ХарактерДеятельности);
	
	Если НЕ ЗначениеЗаполнено(НоменклатурнаяГруппа) Тогда
		
		ТекстСообщения = НСтр("ru = 'Необходимо задать хотя бы одну номенклатурную группу!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "НоменклатурныеГруппы", , Отказ);
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.НоменклатурнаяГруппа)
		ИЛИ НЕ РегистрыСведений.ВидыДеятельностиПредпринимателей.ПолучитьВидДеятельности(
				Объект.ХарактерДеятельности, Объект.НоменклатурнаяГруппа) = Объект.Ссылка Тогда
		
		ТекстСообщения = НСтр("ru = 'Не задана основная номенклатурная группа!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "НоменклатурныеГруппы", , Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.НаименованиеПолное)
		ИЛИ Объект.НаименованиеПолное = Строка(Объект.ХарактерДеятельности) Тогда
		
		Объект.НаименованиеПолное = Объект.Наименование;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ХарактерДеятельностиПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Наименование)
		Или Объект.Наименование = Строка(ХарактерДеятельности) Тогда
		Объект.Наименование       = Строка(Объект.ХарактерДеятельности);
		Объект.НаименованиеПолное = Строка(Объект.ХарактерДеятельности);
	КонецЕсли;
	
	ХарактерДеятельности = Объект.ХарактерДеятельности;
	
	ПроверитьНоменклатурнуюГруппуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактерДеятельностиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ Объект.Ссылка.Пустая() И НЕ ВыбранноеЗначение = Объект.ХарактерДеятельности Тогда
		
		СтандартнаяОбработка = Ложь;
		ДополнительныеПараметры = Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение);
		Оповещение = Новый ОписаниеОповещения("ВопросИзменениеХарактераДеятельностиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		Если ЕстьДвиженияПоВидуДеятельности Тогда
			
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Изменен характер деятельности! Существуют проведенные документы 
					|по виду деятельности ""%1"". Продолжить?'"),
				Объект.Наименование);
			
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		Иначе
			
			ТекстВопроса = НСтр("ru = 'Изменен характер деятельности! Список 
				|номенклатурных групп будет очищен. Продолжить?'");
				
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНоменклатурныеГруппы

&НаКлиенте
Процедура НоменклатурныеГруппыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
		ПоказатьЗначение( , Элемент.ТекущиеДанные.НоменклатурнаяГруппа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатурныеГруппыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Отказ = Истина;
	
	Если Копирование Тогда 
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуПодбораНоменклатурныхГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатурныеГруппыПослеУдаления(Элемент)
	
	ПроверитьНоменклатурнуюГруппуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборНоменклатурныхГрупп(Команда)
	
	ОткрытьФормуПодбораНоменклатурныхГрупп();

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОсновным(Команда)
	
	ТекущиеДанные = Элементы.НоменклатурныеГруппы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НоменклатурнаяГруппа = Элементы.НоменклатурныеГруппы.ТекущиеДанные.НоменклатурнаяГруппа;
	
	Если НЕ Объект.НоменклатурнаяГруппа = НоменклатурнаяГруппа Тогда
		
		Если ЕстьДвиженияПоВидуДеятельности Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Изменена основная номенклатурная группа! Существуют проведенные документы 
					|по виду деятельности ""%1"". Продолжить?'"),
				Объект.Наименование);
				
			Оповещение = Новый ОписаниеОповещения("ВопросИзменениеОсновнойНоменклатурнойГруппыЗавершение", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			Объект.НоменклатурнаяГруппа = Элементы.НоменклатурныеГруппы.ТекущиеДанные.НоменклатурнаяГруппа;
			УстановитьОтборНоменклатурныхГрупп();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораХарактеровДеятельности()

	СписокВыбора = Элементы.ХарактерДеятельности.СписокВыбора;
	
	СписокВыбора.Очистить();
	СписокВыбора.Добавить(Перечисления.ХарактерДеятельности.ОптоваяТорговля);
	СписокВыбора.Добавить(Перечисления.ХарактерДеятельности.РозничнаяТорговляНеЕНВД);
	СписокВыбора.Добавить(Перечисления.ХарактерДеятельности.ПроизводствоРаботыУслуги);
	СписокВыбора.Добавить(Перечисления.ХарактерДеятельности.РозничнаяТорговляЕНВД);
	СписокВыбора.Добавить(Перечисления.ХарактерДеятельности.УслугиЕНВД);
	СписокВыбора.Добавить(Перечисления.ХарактерДеятельности.ВсяДеятельностьНаПатенте);

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборНоменклатурныхГрупп()
	
	НоменклатурныеГруппы.Параметры.УстановитьЗначениеПараметра("ВидДеятельности",              Объект.Ссылка);
	НоменклатурныеГруппы.Параметры.УстановитьЗначениеПараметра("ХарактерДеятельности",         Объект.ХарактерДеятельности);
	НоменклатурныеГруппы.Параметры.УстановитьЗначениеПараметра("ОсновнаяНоменклатурнаяГруппа", Объект.НоменклатурнаяГруппа);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбораНоменклатурныхГрупп()
	
	Если Объект.Ссылка.Пустая() Тогда
	
		Если НЕ ЗаписатьБезПроверкиНаСервере() Тогда
			Возврат;
		КонецЕсли; 
	
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",            Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",                   Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",            Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",  ИспользованиеГруппИЭлементов.Элементы);
	
	ОткрытьФорму("Справочник.НоменклатурныеГруппы.ФормаВыбора", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаСервере
Функция ЗаписатьБезПроверкиНаСервере()
	
	ПроверятьЗаполнениеАвтоматическиДо = ПроверятьЗаполнениеАвтоматически;
	ПроверятьЗаполнениеАвтоматически   = Ложь;
	
	Результат = Записать();
	
	ПроверятьЗаполнениеАвтоматически = ПроверятьЗаполнениеАвтоматическиДо;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ДобавитьВыбранныеНоменклатурныеГруппы(МассивВыбранныхГрупп)
	
	Если Объект.Ссылка.Пустая() ИЛИ НЕ ЗначениеЗаполнено(Объект.ХарактерДеятельности) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписиРегистра = РегистрыСведений.ВидыДеятельностиПредпринимателей.СоздатьМенеджерЗаписи();
	
	НачатьТранзакцию();
	Для каждого НоменклатурнаяГруппа Из МассивВыбранныхГрупп Цикл
		МенеджерЗаписиРегистра.НоменклатурнаяГруппа = НоменклатурнаяГруппа;
		МенеджерЗаписиРегистра.ВидДеятельности      = Объект.Ссылка;
		МенеджерЗаписиРегистра.ХарактерДеятельности = Объект.ХарактерДеятельности;
		МенеджерЗаписиРегистра.Записать(Ложь);
		
		Если НЕ ЗначениеЗаполнено(Объект.НоменклатурнаяГруппа) Тогда
			Объект.НоменклатурнаяГруппа = НоменклатурнаяГруппа;
		КонецЕсли;
		
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
	УстановитьОтборНоменклатурныхГрупп();
	
КонецПроцедуры

// Процедура проверяет соответствие основной номенклатурной группы
// виду деятельностьи, если не соответствует, меняет ее на подходящую
//
&НаСервере
Процедура ПроверитьНоменклатурнуюГруппуНаСервере()
	
	ВидДеятельности = РегистрыСведений.ВидыДеятельностиПредпринимателей.ПолучитьВидДеятельности(
		Объект.ХарактерДеятельности, Объект.НоменклатурнаяГруппа);
	
	Если НЕ ВидДеятельности = Объект.Ссылка Тогда
		Объект.НоменклатурнаяГруппа = РегистрыСведений.ВидыДеятельностиПредпринимателей.ПолучитьПервуюНоменклатурнуюГруппу(Объект.Ссылка, Объект.ХарактерДеятельности);
		Модифицированность = Истина;
	КонецЕсли;
	
	УстановитьОтборНоменклатурныхГрупп();
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросИзменениеХарактераДеятельностиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		НовыйХарактерДеятельности = ДополнительныеПараметры.ВыбранноеЗначение;
		Объект.ХарактерДеятельности = НовыйХарактерДеятельности;
		
		Если ПустаяСтрока(Объект.Наименование) Тогда
			Объект.Наименование       = Строка(НовыйХарактерДеятельности);
			Объект.НаименованиеПолное = Строка(НовыйХарактерДеятельности);
		КонецЕсли;
		
		ПроверитьНоменклатурнуюГруппуНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросИзменениеОсновнойНоменклатурнойГруппыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.НоменклатурнаяГруппа = Элементы.НоменклатурныеГруппы.ТекущиеДанные.НоменклатурнаяГруппа;
		УстановитьОтборНоменклатурныхГрупп();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти