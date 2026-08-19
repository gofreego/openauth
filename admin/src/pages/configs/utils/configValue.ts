import { ValueType } from '../../../apis/proto/openauth/v1/configs'
import type { Config } from '../../../apis/proto/openauth/v1/configs'

export const VALUE_TYPE_OPTIONS = [
  { value: ValueType.VALUE_TYPE_STRING, label: 'String' },
  { value: ValueType.VALUE_TYPE_INT, label: 'Integer' },
  { value: ValueType.VALUE_TYPE_FLOAT, label: 'Float' },
  { value: ValueType.VALUE_TYPE_BOOL, label: 'Boolean' },
  { value: ValueType.VALUE_TYPE_JSON, label: 'JSON' },
]

export function valueTypeLabel(type: ValueType): string {
  return VALUE_TYPE_OPTIONS.find((o) => o.value === type)?.label ?? 'Unknown'
}

export function displayValue(config: Config): string {
  switch (config.type) {
    case ValueType.VALUE_TYPE_STRING:
      return config.stringValue ?? ''
    case ValueType.VALUE_TYPE_INT:
      return config.intValue ?? ''
    case ValueType.VALUE_TYPE_FLOAT:
      return config.floatValue !== undefined ? String(config.floatValue) : ''
    case ValueType.VALUE_TYPE_BOOL:
      return config.boolValue ? 'true' : 'false'
    case ValueType.VALUE_TYPE_JSON:
      return config.jsonValue ?? ''
    default:
      return ''
  }
}

/** Build the value-bearing fields of a Create/Update request from a raw string input. */
export function buildValueFields(type: ValueType, raw: string): {
  stringValue?: string
  intValue?: string
  floatValue?: number
  boolValue?: boolean
  jsonValue?: string
} {
  switch (type) {
    case ValueType.VALUE_TYPE_STRING:
      return { stringValue: raw }
    case ValueType.VALUE_TYPE_INT:
      return { intValue: raw }
    case ValueType.VALUE_TYPE_FLOAT:
      return { floatValue: parseFloat(raw) || 0 }
    case ValueType.VALUE_TYPE_BOOL:
      return { boolValue: raw === 'true' }
    case ValueType.VALUE_TYPE_JSON:
      return { jsonValue: raw }
    default:
      return { stringValue: raw }
  }
}
