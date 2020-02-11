object ServerContainer1: TServerContainer1
  OldCreateOrder = False
  Height = 271
  Width = 415
  object DSServer1: TDSServer
    Left = 56
    Top = 115
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    Port = 212
    Server = DSServer1
    Filters = <>
    Left = 120
    Top = 40
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    Left = 152
    Top = 139
  end
end
