import * as Vue from "https://cdn.jsdelivr.net/npm/vue@3.2.45/dist/vue.esm-browser.prod.js";

function range(start, end) {
  return Array.apply(0, Array(end - start + 1))
    .map((_element, index) => index + start);
}

function lastYear() {
  // Fix the timestamp with the EST (UTC-5) timezone
  const timestamp = new Date().getTime() - 5 * 60 * 60 * 1000;
  const now = new Date(timestamp);
  const [year, month] = [now.getUTCFullYear(), now.getUTCMonth()];
  return month === 11 ? year : year - 1;
}

function getAvailableYears() {
  return range(2015, lastYear()).reverse().map((value) => ({
    label: `${value}`,
    value: `${value}`,
  }));
}

function getAvailableDays() {
  return range(1, 25).map((value) => ({
    label: `${value}`.padStart(2, "0"),
    value: `${value}`,
  }));
}

export function init(ctx, info) {
  ctx.importCSS("main.css");
  ctx.importCSS(
    "https://fonts.googleapis.com/css2?family=Inter:wght@400;500&display=swap",
  );

  const BaseSelect = {
    name: "BaseSelect",

    props: {
      label: {
        type: String,
        default: "",
      },
      selectClass: {
        type: String,
        default: "input",
      },
      modelValue: {
        type: String,
        default: "",
      },
      options: {
        type: Array,
        default: [],
        required: true,
      },
      required: {
        type: Boolean,
        default: false,
      },
      inline: {
        type: Boolean,
        default: false,
      },
      grow: {
        type: Boolean,
        default: false,
      },
    },

    methods: {
      available(value, options) {
        return value
          ? options.map((option) => option.value).includes(value)
          : true;
      },
    },

    template: `
    <div v-bind:class="[inline ? 'inline-field' : 'field', grow ? 'grow' : '']">
      <label v-bind:class="inline ? 'inline-input-label' : 'input-label'">
        {{ label }}
      </label>
      <select
        :value="modelValue"
        v-bind="$attrs"
        @change="$emit('update:modelValue', $event.target.value)"
        v-bind:class="[selectClass, { unavailable: !available(modelValue, options) }]"
      >
        <option v-if="!required && !available(modelValue, options)"></option>
        <option
          v-for="option in options"
          :value="option.value"
          :key="option"
          :selected="option.value === modelValue"
        >{{ option.label }}</option>
        <option
          v-if="!available(modelValue, options)"
          class="unavailable"
          :value="modelValue"
        >{{ modelValue }}</option>
      </select>
    </div>
    `,
  };

  const BaseInput = {
    name: "BaseInput",

    props: {
      label: {
        type: String,
        default: "",
      },
      inputClass: {
        type: String,
        default: "input",
      },
      modelValue: {
        type: [String, Number],
        default: "",
      },
      inline: {
        type: Boolean,
        default: false,
      },
      grow: {
        type: Boolean,
        default: false,
      },
      number: {
        type: Boolean,
        default: false,
      },
    },

    computed: {
      emptyClass() {
        if (this.modelValue === "") {
          return "empty";
        }
      },
    },

    template: `
    <div v-bind:class="[inline ? 'inline-field' : 'field', grow ? 'grow' : '']">
      <label v-bind:class="inline ? 'inline-input-label' : 'input-label'">
        {{ label }}
      </label>
      <input
        :value="modelValue"
        @input="$emit('update:modelValue', $event.target.value)"
        v-bind="$attrs"
        v-bind:class="[inputClass, number ? 'input-number' : '', emptyClass]"
      >
    </div>
    `,
  };

  const BaseSecret = {
    name: "BaseSecret",

    components: {
      BaseInput: BaseInput,
      BaseSelect: BaseSelect,
    },

    props: {
      textInputName: {
        type: String,
        default: "",
      },
      secretInputName: {
        type: String,
        default: "",
      },
      toggleInputName: {
        type: String,
        default: "",
      },
      label: {
        type: String,
        default: "",
      },
      grow: {
        type: Boolean,
        default: false,
      },
      selectClass: {
        type: String,
        default: "input",
      },
      toggleInputValue: {
        type: [String, Number],
        default: "",
      },
      secretInputValue: {
        type: [String, Number],
        default: "",
      },
      textInputValue: {
        type: [String, Number],
        default: "",
      },
      modalTitle: {
        type: String,
        default: "Select secret",
      },
    },

    methods: {
      selectSecret() {
        const preselectName = this.secretInputValue;
        ctx.selectSecret(
          (secretName) => {
            ctx.pushEvent("update_field", {
              field: this.secretInputName,
              value: secretName,
            });
          },
          preselectName,
          { title: this.modalTitle },
        );
      },
    },

    template: `
      <div class="input-icon-container inline-input-label grow">
        <BaseInput
          v-if="toggleInputValue"
          :name="secretInputName"
          :label="label"
          :value="secretInputValue"
          inputClass="input input--xs input-icon"
          readonly
          @click="selectSecret"
          @input="$emit('update:secretInputValue', $event.target.value)"
        />
        <BaseInput
          v-else
          :name="textInputName"
          :label="label"
          type="text"
          :value="textInputValue"
          inputClass="input input--xs input-icon-text"
          @input="$emit('update:textInputValue', $event.target.value)"
        />
        <div class="icon-container">
          <label class="hidden-checkbox">
            <input
              type="checkbox"
              :name="toggleInputName"
              :checked="toggleInputValue"
              @input="$emit('update:toggleInputValue', $event.target.checked)"
              class="hidden-checkbox-input"
            />
            <svg v-if="toggleInputValue" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                  width="22" height="22">
              <path fill="none" d="M0 0h24v24H0z"/>
              <path d="M18 8h2a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1h2V7a6 6 0 1 1 12 0v1zM5
                10v10h14V10H5zm6 4h2v2h-2v-2zm-4 0h2v2H7v-2zm8 0h2v2h-2v-2zm1-6V7a4 4 0 1 0-8 0v1h8z" fill="#000"/>
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
              <path fill="none" d="M0 0h24v24H0z"/>
              <path d="M21 3v18H3V3h18zm-8.001 3h-2L6.6 17h2.154l1.199-3h4.09l1.201 3h2.155l-4.4-11zm-1 2.885L13.244
                12h-2.492l1.247-3.115z" fill="#445668"/>
            </svg>
          </label>
        </div>
      </div>
    `,
  };

  const app = Vue.createApp({
    components: {
      BaseInput: BaseInput,
      BaseSelect: BaseSelect,
      BaseSecret: BaseSecret,
    },

    template: `
    <div class="app">
      <!-- Info Messages -->
      <div id="info-box" class="info-box" v-if="missingDep">
        <p>To successfully connect, you need to add the following dependency:</p>
        <span>{{ missingDep }}</span>
      </div>
      <form @change="handleFieldChange">
        <div class="container">
          <div class="row header">
            <BaseSelect
              name="year"
              label=" Year "
              v-model="fields.year"
              selectClass="input input--xs"
              :options="availableYears"
              :grow
            />
            <BaseSelect
              name="day"
              label=" Day "
              v-model="fields.day"
              selectClass="input input--xs"
              :options="availableDays"
              :grow
            />
            <BaseSecret
              textInputName="session"
              secretInputName="session_secret"
              toggleInputName="use_session_secret"
              label=" Session "
              v-model:textInputValue="fields.session"
              v-model:secretInputValue="fields.session_secret"
              v-model:toggleInputValue="fields.use_session_secret"
              modalTitle="Set Session ID"
              :grow
            />
            <BaseInput
              name="variable"
              label=" Assign to "
              type="text"
              v-model="fields.variable"
              inputClass="input input--xs input-text"
              :grow
            />
          </div>
        </div>
      </form>
    </div>
    `,

    data() {
      return {
        fields: info.fields,
        missingDep: info.missing_dep,
        helpBox: info.help_box,
        availableYears: getAvailableYears(),
        availableDays: getAvailableDays(),
      };
    },

    methods: {
      handleFieldChange(event) {
        const field = event.target.name;
        if (field) {
          const value = this.fields[field];
          ctx.pushEvent("update_field", { field, value });
        }
      },
    },
  }).mount(ctx.root);

  ctx.handleEvent("update", ({ fields }) => {
    setValues(fields);
  });

  ctx.handleEvent("missing_dep", ({ dep }) => {
    app.missingDep = dep;
  });

  ctx.handleSync(() => {
    // Synchronously invokes change listeners
    document.activeElement &&
      document.activeElement.dispatchEvent(
        new Event("change", { bubbles: true }),
      );
  });

  function setValues(fields) {
    for (const field in fields) {
      app.fields[field] = fields[field];
    }
  }
}
