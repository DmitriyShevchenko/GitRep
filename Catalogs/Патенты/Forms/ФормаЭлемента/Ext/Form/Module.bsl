﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Элементы.Владелец.Видимость = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	Элементы.НалоговаяСумма.ТолькоПросмотр = ТолькоПросмотр;
	
	ОдинПлатеж = ОдинПлатеж(Объект.ДатаНачала, Объект.ДатаОкончания);
	
	ПересчитатьСуммуНалога(ЭтотОбъект);
	
	УстановитьДоступностьНалоговогоОргана(ЭтотОбъект);
	
	УстановитьЗаголовокСвернутогоОтображенияПостановкаНаУчетВНО();
	
	УстановитьПредставлениеГруппыОплата(ЭтотОбъект);
	
	Параметры.Свойство("СозданИзФормыДокумента", СозданИзФормыДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Данные информационной базы, влияющие на список КБК
	Если Не ТекущийОбъект.ПометкаУдаления
	   И Прав(ТекущийОбъект.КБК, 3) = "110" Тогда
	   
		КатегорияПодчинения = Сред(ТекущийОбъект.КБК, 9, 3);
		КатегорииПодчинения = Перечисления.УсловияПримененияТребованийЗаконодательства.КатегорииПодчиненияПатентовПоВидамНалогов();
		Если КатегорииПодчинения.Найти(КатегорияПодчинения) = Неопределено Тогда
			ПараметрыЗаписи.Вставить("ПоявиласьНоваяКатегорияПодчиненияПоВидуНалога", Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СтруктураПараметров = Новый Структура("Владелец, Ссылка");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, Объект);
	
	Если ПараметрыЗаписи.Свойство("РезультатВыполненияЗаданияКалендаряБухгалтера") Тогда
		КалендарьБухгалтераКлиент.ОжидатьЗавершениеЗаполненияВФоне(ПараметрыЗаписи.РезультатВыполненияЗаданияКалендаряБухгалтера);
	КонецЕсли;
	
	Оповестить("ИзменениеПатента", СтруктураПараметров, ЭтотОбъект);
	
	Если СозданИзФормыДокумента Тогда
		ОповеститьОВыборе(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.ПометкаУдаления
		И ПараметрыЗаписи.Свойство("ПоявиласьНоваяКатегорияПодчиненияПоВидуНалога") Тогда
		Справочники.ВидыНалоговИПлатежейВБюджет.СоздатьПоставляемыеЭлементы();
	КонецЕсли;
	
	РезультатВыполнения = КалендарьБухгалтера.ЗапуститьЗаполнениеВФоне(УникальныйИдентификатор, ТекущийОбъект.Владелец, Ложь, Истина);
	ПараметрыЗаписи.Вставить("РезультатВыполненияЗаданияКалендаряБухгалтера", РезультатВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(Объект.НомерПатента) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Номер патента'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.НомерПатента", , Отказ);
	КонецЕсли;
		
	Если СуммаНалога > 0  И НЕ ЗначениеЗаполнено(Объект.КБК) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'КБК'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.КБК", , Отказ);
	КонецЕсли;
	
	Если Объект.СуммаВторогоПлатежа > 0 И Объект.СуммаПервогоПлатежа > 0
		И НЕ (Объект.ДатаНачала <= Объект.ДатаПервогоПлатежа И Объект.ДатаПервогоПлатежа <= Объект.ДатаОкончания) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "КОРРЕКТНОСТЬ", НСтр("ru = 'Дата первого платежа'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ДатаПервогоПлатежа", , Отказ);
	КонецЕсли;
	
	Если Объект.ПостановкаНаУчетВНалоговомОргане =
			Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.НалоговыйОрган) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Налоговый орган'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.НалоговыйОрган", , Отказ);
		ИначеЕсли НЕ ЗначениеЗаполнено(Объект.КодПоОКТМО) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'ОКТМО'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.КодПоОКТМО", , Отказ);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаОкончания)
		ИЛИ Объект.ДатаНачала > Объект.ДатаОкончания
		ИЛИ Год(Объект.ДатаОкончания) <> Год(Объект.ДатаНачала) Тогда
		
		Объект.ДатаОкончания = КонецГода(Объект.ДатаНачала);
		
	КонецЕсли;
	
	РассчитатьПлатеж();
	УстановитьПредставлениеГруппыОплата(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала)
		ИЛИ Объект.ДатаНачала > Объект.ДатаОкончания
		ИЛИ Год(Объект.ДатаОкончания) <> Год(Объект.ДатаНачала) Тогда
		
		Объект.ДатаНачала = НачалоГода(Объект.ДатаОкончания);
		
	КонецЕсли;
	
	РассчитатьПлатеж();
	УстановитьПредставлениеГруппыОплата(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодБКНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыборКода("КБК", "КБК");
	
КонецПроцедуры

&НаКлиенте
Процедура ПостановкаНаУчетВНалоговомОрганеПриИзменении(Элемент)
	
	УстановитьДоступностьНалоговогоОргана(ЭтотОбъект);
	
	УстановитьЗаголовокСвернутогоОтображенияПостановкаНаУчетВНО();
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговыйОрганПриИзменении(Элемент)
	
	НалоговыйОрганПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговаяСуммаПриИзменении(Элемент)
	
	РассчитатьПлатеж(Ложь);
	УстановитьПредставлениеГруппыОплата(ЭтотОбъект);
	
КонецПроцедуры


&НаКлиенте
Процедура СуммаПервогоПлатежаПриИзменении(Элемент)
	
	ПересчитатьСуммуНалога(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаВторогоПлатежаПриИзменении(Элемент)
	
	ПересчитатьСуммуНалога(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПервогоПлатежаПриИзменении(Элемент)
	
	УстановитьПредставлениеГруппыОплата(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыФормы = Новый Структура("НачалоПериода, КонецПериода", Объект.ДатаНачала, Объект.ДатаОкончания);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыФормы, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДатаНачала    = РезультатВыбора.НачалоПериода;
	Объект.ДатаОкончания = РезультатВыбора.КонецПериода;
	
	РассчитатьПлатеж();
	УстановитьПредставлениеГруппыОплата(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьБанк(Команда)
	
	Оплатить(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьНаличными(Команда)
	
	Оплатить(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявлениеУтратаПраваНаПатент(Команда)
	
	СоздатьЗаявление(
		ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявлениеПрекращениеДеятельности(Команда)
	
	СоздатьЗаявление(
		ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме"));
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НалоговыйОрганПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.НалоговыйОрган) Тогда 
		Объект.КодПоОКТМО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.НалоговыйОрган,"КодПоОКТМО");
	КонецЕсли;
	
	УстановитьЗаголовокСвернутогоОтображенияПостановкаНаУчетВНО();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокСвернутогоОтображенияПостановкаНаУчетВНО()
	
	Если Объект.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ПоМестуНахожденияОрганизации Тогда
		
		ТекстПостановкаНаУчетВНалоговомОргане = НСтр("ru = 'Налоговая инспекция: по месту жительства'");
		
	ИначеЕсли Объект.ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		
		Если ЗначениеЗаполнено(Объект.НалоговыйОрган) Тогда
			Шаблон = НСтр("ru = 'Налоговая инспекция: %1 %2'");
			РеквизитыИФНС = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.НалоговыйОрган, "Код, Наименование");
			ТекстПостановкаНаУчетВНалоговомОргане = СтрШаблон(Шаблон, РеквизитыИФНС.Код, РеквизитыИФНС.Наименование);
			
		Иначе
			ТекстПостановкаНаУчетВНалоговомОргане = НСтр("ru='Налоговая инспекия: <...>'");
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьЗаголовокГруппы(ЭтотОбъект, "ГруппаПостановкаНаУчетВНалоговомОргане", ТекстПостановкаНаУчетВНалоговомОргане);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокГруппы(ЭтотОбъект, НазваниеГруппы, ЗаголовокТекст)
	
	ЭтотОбъект.Элементы[НазваниеГруппы].ЗаголовокСвернутогоОтображения = ЗаголовокТекст;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьНалоговогоОргана(Форма)
	
	Объект = Форма.Объект;
	ПостановкаНаУчетВНО = Объект.ПостановкаНаУчетВНалоговомОргане;
	
	ПостановкаВДругомНО = ПостановкаНаУчетВНО = ПредопределенноеЗначение("Перечисление.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане");
	
	Форма.Элементы.ГруппаРеквизиты.Доступность = ПостановкаВДругомНО;
	Если НЕ ПостановкаВДругомНО тогда
		Объект.КодПоОКТМО = "";
		Объект.НалоговыйОрган = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКода(ИмяКода, НазваниеМакета)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта",		"Справочник");
	ПараметрыФормы.Вставить("НазваниеОбъекта",	"Патенты");
	ПараметрыФормы.Вставить("НазваниеМакета",	НазваниеМакета);
	ПараметрыФормы.Вставить("ТекущийПериод",	Объект.ДатаНачала);
	ПараметрыФормы.Вставить("ТекущийКод",		Объект[ИмяКода]);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяКода", ИмяКода);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборКодаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораКода", ПараметрыФормы,,,,,ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКодаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ИмяКода = ДополнительныеПараметры.ИмяКода;	
	
	ВыбранныйКод = РезультатЗакрытия;	
	
	Если ВыбранныйКод <> Неопределено Тогда
		
		Модифицированность = Истина;
		
		Объект[ИмяКода] = ВыбранныйКод;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеГруппыОплата(Форма);
	
	ШаблонОплата = НСтр("ru = 'Оплата: %1'");
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Форма.ОдинПлатеж Тогда
		
		ТекстОплата = СтрШаблон(ШаблонОплата, "полная сумма не позднее "+ Формат(Объект.ДатаПервогоПлатежа,"ДЛФ=D"));
		НоваяТекущаяСтраница = Элементы.ГруппаСтраницаПолнаяСумма;
		
	Иначе
		
		Если НЕ ЗначениеЗаполнено(Объект.ДатаПервогоПлатежа)
			ИЛИ НЕ ЗначениеЗаполнено(Объект.ДатаВторогоПлатежа)
			ИЛИ НЕ ЗначениеЗаполнено(Объект.СуммаПервогоПлатежа)
			ИЛИ НЕ ЗначениеЗаполнено(Объект.СуммаВторогоПлатежа) Тогда
			ТекстОплата = СтрШаблон(ШаблонОплата," не указана");
			
		Иначе
			ТекстОплата = СтрШаблон(ШаблонОплата, Строка(Объект.СуммаПервогоПлатежа) + " руб. не позднее "+ Формат(Объект.ДатаПервогоПлатежа,"ДЛФ=D")
				+ ", " + Строка(Объект.СуммаВторогоПлатежа)+ " руб. не позднее "+ Формат(Объект.ДатаВторогоПлатежа,"ДЛФ=D"));
			
		КонецЕсли;
		
		НоваяТекущаяСтраница = Элементы.ГруппаСтраницаОплатаПоЧастям;
		
	КонецЕсли;
	
	Элементы.ГруппаСтраницыСуммаНалога.ТекущаяСтраница = НоваяТекущаяСтраница;
	УстановитьЗаголовокГруппы(Форма, "ГруппаОплата", ТекстОплата);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОдинПлатеж(ДатаНачала, ДатаОкончания)
	
	ПериодВторогоПлатежа = НачалоДня( ДобавитьМесяц(ДатаНачала, 5));
	
	Возврат ПериодВторогоПлатежа > НачалоДня(КонецГода(ДатаНачала))
			ИЛИ ПериодВторогоПлатежа > ДатаОкончания;
	
КонецФункции

&НаКлиенте
Процедура РассчитатьПлатеж(ПересчитатьСуммуНалога = Истина)
	
	Если ПересчитатьСуммуНалога Тогда
		НалоговаяБаза = ПотенциальноВозможныйДоход(
		Объект.ПотенциальноВозможныйГодовойДоход, Объект.ДатаНачала, Объект.ДатаОкончания);
	
		НалоговаяСтавка = УчетУСНКлиентСервер.НалоговаяСтавкаПоПатентнойСистеме(Объект.ДатаНачала);
	
		СуммаНалога = Окр(НалоговаяБаза * НалоговаяСтавка, 0);
	
	КонецЕсли;

	ОдинПлатеж = ОдинПлатеж(Объект.ДатаНачала, Объект.ДатаОкончания);
	
	Если СуммаНалога = 0 Тогда
		Объект.СуммаПервогоПлатежа = 0;
		Объект.ДатаПервогоПлатежа = '00010101';
		Объект.СуммаВторогоПлатежа = 0;
		Объект.ДатаВторогоПлатежа = '00010101';
	Иначе
		
		Если ОдинПлатеж тогда
			Объект.СуммаПервогоПлатежа = СуммаНалога;
			Объект.ДатаПервогоПлатежа = Объект.ДатаОкончания;
			Объект.СуммаВторогоПлатежа = 0;
			Объект.ДатаВторогоПлатежа = '00010101';
		Иначе
			Объект.СуммаПервогоПлатежа = Окр(СуммаНалога/3);
			Объект.ДатаПервогоПлатежа = Объект.ДатаНачала+89*86400;
			Объект.СуммаВторогоПлатежа = СуммаНалога - Окр(СуммаНалога/3);
			Объект.ДатаВторогоПлатежа = Объект.ДатаОкончания;
		КонецЕсли;
		
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПересчитатьСуммуНалога(Форма)
	
	Форма.СуммаНалога = Форма.Объект.СуммаПервогоПлатежа + Форма.Объект.СуммаВторогоПлатежа;
	
	УстановитьПредставлениеГруппыОплата(Форма);
	
КонецФункции

&НаКлиенте
Процедура ПотенциальноВозможныйГодовойДоходПриИзменении(Элемент)
	
	РассчитатьПлатеж();
	УстановитьПредставлениеГруппыОплата(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПотенциальноВозможныйДоход(ПотенциальноВозможныйГодовойДоход, ДатаНачала, ДатаОкончания)
	
	ПотенциальноВозможныйДоход = УчетУСНКлиентСервер.РассчитатьПотенциальноВозможныйДоход(
		ПотенциальноВозможныйГодовойДоход, ДатаНачала, ДатаОкончания);
	
	Возврат ПотенциальноВозможныйДоход;
	
КонецФункции

&НаКлиенте
Процедура Оплатить(ИмяКоманды)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) ИЛИ Модифицированность Тогда
		Если НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеПатента = ПолучитьДанныеПатента(Объект.Ссылка);

	Если ДанныеПатента.ОплаченПолностью Тогда
		ТекстПредупреждения = НСтр("ru = 'Патент ""%1"" на сумму %2 руб. оплачен полностью'");
		ПоказатьПредупреждение(, СтрШаблон(ТекстПредупреждения, ДанныеПатента.Наименование, ДанныеПатента.СуммаПлатежаПолного));
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Перед оплатой необходимо заполнить данные о патенте");
		Возврат;
	Иначе
		
		СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыУплатыНалогов.НаличнымиПоКвитанции");
		Если ИмяКоманды = "ОплатитьБанк" Тогда
			СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыУплатыНалогов.БанковскийПеревод");
		КонецЕсли;
		
		ДанныеПатента.Вставить("СпособОплаты", СпособОплаты);
		
		Если ЗначениеЗаполнено(ДанныеПатента.СписокПлатежей) Тогда
			
			ОбработкаОповещения = Новый ОписаниеОповещения("ОплатитьВыборЗавершение", ЭтотОбъект);
			ПараметрыФормы = Новый Структура("ДанныеПатента", ДанныеПатента);
			
			ОткрытьФорму("Справочник.Патенты.Форма.ФормаОплаты", ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор,,,ОбработкаОповещения);
		Иначе
			ОписаниеПараметровОплаты = ПолучитьОписаниеОплатыПатента(ДанныеПатента);
			ОткрытьФорму(ОписаниеПараметровОплаты.ИмяФормы, ОписаниеПараметровОплаты.ПараметрыФормы);
		КонецЕсли;
		
	КонецЕсли;
	
Конецпроцедуры

&НаКлиенте
Процедура ОплатитьВыборЗавершение(ДанныеПатента, ДополнительныеПараметры) Экспорт
	
	Если ДанныеПатента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеПараметровОплаты = ПолучитьОписаниеОплатыПатента(ДанныеПатента);
	ОткрытьФорму(ОписаниеПараметровОплаты.ИмяФормы, ОписаниеПараметровОплаты.ПараметрыФормы);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеПатента(Патент)
	Возврат Справочники.Патенты.ДанныеПатента(Патент);
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьОписаниеОплатыПатента(ДанныеПатента)
	
	Возврат Справочники.Патенты.ОписаниеОплатыПатента(ДанныеПатента);
	
КонецФункции

&НаКлиенте
Процедура СоздатьЗаявление(ВидЗаявления)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Организация", Объект.Владелец);
	
	Если ВидЗаявления = ПредопределенноеЗначение(
		"Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме") Тогда
		
		ПараметрыЗаполнения = Новый Структура;
		ПараметрыЗаполнения.Вставить("Патент", Объект.Ссылка);
		ПараметрыФормы.Вставить("ПараметрыЗаполнения", ПараметрыЗаполнения);
		
	КонецЕсли;
	
	ПараметрыФормы.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);

	УчетПСНКлиент.ОткрытьФормуЗаявления(ВидЗаявления, ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
