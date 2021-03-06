﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ФормированиеЗапросаКлассификатора_Завершение", ЭтотОбъект);
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеЗапросаОрганизаций(ОповещениеПриЗавершении, ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗапросаКлассификатора());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ФормированиеЗапросаКлассификатора_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат.Результат Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьПредупреждение(, НСтр("ru = 'Запрос на загрузку классификатора сформирован.'"), 10);
	
КонецПроцедуры

#КонецОбласти