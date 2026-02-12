[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "holidaydatacontainer_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "countryOrRegion", DestinationColumnName = "countryOrRegion"], [SourceColumnName = "holidayName", DestinationColumnName = "holidayName"], [SourceColumnName = "normalizeHolidayName", DestinationColumnName = "normalizeHolidayName"], [SourceColumnName = "isPaidTimeOff", DestinationColumnName = "isPaidTimeOff"], [SourceColumnName = "countryRegionCode", DestinationColumnName = "countryRegionCode"], [SourceColumnName = "date", DestinationColumnName = "date"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared holidaydatacontainer = let
  Source = Lakehouse.Contents(null),
  #"Navigation 1" = Source{[workspaceId = WorkspaceID]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = LakehouseID]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "holidaydatacontainer", ItemKind = "Table"]}[Data],
  #"Filtered rows" = Table.SelectRows(#"Navigation 3", each [countryOrRegion] = Region)
in
  #"Filtered rows";
shared WorkspaceID = let
  WorkspaceId = Variable.ValueOrDefault("$(/**/dataflow-Variables/WorkspaceID)", "4b8649bd-c1d8-4cf2-9a6a-d7353d435742")
in
  WorkspaceId;
shared LakehouseID = let
LakehouseId =
  Variable.ValueOrDefault("$(/\*\*/dataflow-Variables/LakehouseID)",
"db0abc0f-4cb4-4657-8401-85680826b11d")
in
LakehouseId;
shared Region = let
  Source = Variable.ValueOrDefault("$(/**/dataflow-Variables/Region)", "Sweden")
in
Source;
shared holidaydatacontainer_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = null, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "4b8649bd-c1d8-4cf2-9a6a-d7353d435742"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "cc69465f-cb6a-4295-841c-da64a6d6128b"]}[Data],
  TableNavigation = Navigation_2{[Item = "holidaydatacontainer", Schema = "dbo"]}?[Data]?
in
  TableNavigation;
